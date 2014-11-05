<%@ page import="similarity.mapper.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<html>

<head>
<script type="" src="JavascriptFile.js"></script>
</head>

<body>

	<% 
	try {
		System.out.println("Inside index.jsp");
		String str[] = new String[2];
		String fileName[] = new String[2];
		
		/* Contains the FIRST question paper */
		str[0] = request.getParameter("TA1");
		/* Contains the SECOND question paper */
		str[1] = request.getParameter("TA2");
		
		fileName[0] = request.getParameter("fileText1");
		fileName[1] = request.getParameter("fileText2");

		System.out.println("fileName[0]: " + fileName[0]);
		System.out.println("fileName[1]: " + fileName[1]);
		
		
		int i1 = 0;
		Question Q[][] = new Question[2][50];
		int numOfQuestions[] = new int[2];

		Mapper m = new Mapper("D:\\Implementation\\data\\DMver1.owl");
		m.ReadOntology();

		int z = 0, z1 = 0;
		NodeCapsule MappedNodes1[][] = new NodeCapsule[100][100];
		NodeCapsule MappedNodes2[][] = new NodeCapsule[100][100];
		int count[][] = new int[2][100];
		while (z < 2) {
			if (fileName[z] != "") {
				str[z] = "";
				System.out.println("Filename " + z + ": " + fileName[z]);
				fileName[z] = fileName[z].substring(fileName[z].lastIndexOf('\\') + 1, fileName[z].length());
				System.out.println("After trim, filename " + z + ": " + fileName[z]);
				FileInputStream fstream = new FileInputStream("E:" + fileName[z]);
				DataInputStream in = new DataInputStream(fstream);
				BufferedReader br = new BufferedReader(new InputStreamReader(in));

				String strLine;
				while ((strLine = br.readLine()) != null) {
					str[z] += (" " + strLine);
				}

			}
			numOfQuestions[z] = 0;
			int counttemp = 0;
			int hashLocation[] = new int[1000];

			for (int i = 0; i < str[z].length(); i++) {
				if (str[z].charAt(i) == '#') {
					hashLocation[numOfQuestions[z]] = i;
					numOfQuestions[z]++;
				}
			}
			// System.out.println(str[i1]);
			// System.out.println("No of question"+numOfQuestions[i1]);
			hashLocation[numOfQuestions[z]] = str[z].length() - 1; // Adding one last hash at the end
			String questionPaper[] = new String[numOfQuestions[z]];

			for (int i = 0; i < str[z].length(); i++) {
				if (str[z].charAt(i) == '#') {
					if (counttemp == numOfQuestions[z] - 1) // For the last question
					{
						questionPaper[counttemp] = str[z].substring(hashLocation[counttemp] + 1, str[z].length());

					} else {
						questionPaper[counttemp] = str[z].substring(hashLocation[counttemp] + 1, (hashLocation[counttemp + 1] - 1));

					}

					/* Remove question number */
					questionPaper[counttemp] = questionPaper[counttemp].substring(questionPaper[counttemp].indexOf('.') + 2,
							questionPaper[counttemp].length());
					// System.out.println(questionPaper[count]);
					//out.println(questionPaper[count]+"<br>");
					counttemp++;

				}
			}

			for (int x = 0; x < numOfQuestions[z]; x++) {

				Q[z][x] = new Question();
			}

			if (z == 0) {
				System.out.println("numOfQuestions in paper " + (z+1) + ": " + numOfQuestions[z]);
				while (z1 < numOfQuestions[z]) {
					int noOfNodesMapped = 0;
					NodeCapsule nodesMapped[] = new NodeCapsule[1000];// assuming 100 node structure
					String concepts[] = new String[1000];//100 concepts

					StringTokenizer st = new StringTokenizer(questionPaper[z1], "?., ");//for tokenizing the question
					int numOfWords = st.countTokens();//counts number of words
					String a[] = new String[numOfWords];//array of token to store all the tokens.
					boolean flag[] = new boolean[numOfWords];//Flag for encountered keywords
					for (int i = 0; i < numOfWords; i++)
						flag[i] = true;
					boolean isColored[] = new boolean[numOfWords];// to color keywords with red.
					int i = 0;

					while (st.hasMoreTokens()) {
						a[i] = st.nextToken();// to fill the token array.
						i++;
					}

					int windowStart, windowEnd; //windows used to implement ngram logic.
					String questionSubstring, concept;
					int pos[] = new int[1000];

					i1 = 0;
					for (i1 = 0; i1 < 10; i1++)
						pos[i1] = -1;
					i1 = 0;
					// System.out.println("\n\nQuestion: "+str[z]);

					for (int windowSize = numOfWords; windowSize > 0; windowSize--) {
						//System.out.println("Window size: "+windowSize);
						windowStart = 0;
						windowEnd = windowSize;
						//start of ngram logic
						do {
							questionSubstring = "";
							//System.out.println("Start: "+windowStart+", End: "+windowEnd);
							int pointer = 0;
							for (pointer = windowStart; (pointer < windowEnd) && (flag[pointer] != false); pointer++)
								questionSubstring = questionSubstring.concat((" " + a[pointer])).trim();
							//System.out.println(questionSubstring);
							for (i = 0; i < m.totalAnnotationCount; i++) {
								concept = m.conceptList[i].keyword;

								if (concept.equalsIgnoreCase(questionSubstring)) {
									for (pointer = windowStart; pointer < windowEnd; pointer++) {
										flag[pointer] = false;
										isColored[pointer] = true;

									}
									concepts[noOfNodesMapped] = questionSubstring;
									nodesMapped[noOfNodesMapped] = m.conceptList[i].associatedNode;
									noOfNodesMapped++;
									pos[i1++] = i;
								}
							}
							windowStart++;
							windowEnd++;

						} while (windowEnd <= numOfWords);
					}

					Q[z][z1].nodesMapped = new NodeCapsule[noOfNodesMapped];
					Q[z][z1].test = new NodeCapsule[noOfNodesMapped];
					Q[z][z1].concepts = new String[noOfNodesMapped];
					//q.question = new String[numOfWords];
					Q[z][z1].question = questionPaper[z1];
					//q.marks = marks;
					Q[z][z1].noOfNodesMapped = noOfNodesMapped;
					for (i = 0; i < noOfNodesMapped; i++) {
						Q[z][z1].concepts[i] = concepts[i];
						Q[z][z1].nodesMapped[i] = nodesMapped[i];
						Q[z][z1].test[i] = nodesMapped[i];
					}
					Q[z][z1].checkAncestors(m);

					/* TODO: Problem */
// 					System.out.print("Q: " + Q);
					MappedNodes1[z1] = Q[z][z1].propogate(m);

					count[z][z1] = Q[z][z1].Mapcount;
					
					System.out.print(questionPaper[z1]);
					
					for (i = 0; i < count[z][z1]; i++)
						System.out.print("For QP 1, Question no. " + z1 + ": " + MappedNodes1[z1][i].name + " ");
					System.out.println();

					z1++;
				}
				z++;
			} else {
				z1 = 0;
				while (z1 < numOfQuestions[z]) {
					int noOfNodesMapped = 0;
					NodeCapsule nodesMapped[] = new NodeCapsule[100];// assuming 100 node structure
					String concepts[] = new String[100];//100 concepts

					StringTokenizer st = new StringTokenizer(questionPaper[z1], "?., ");//for tokenizing the question
					int numOfWords = st.countTokens();//counts number of words
					String a[] = new String[numOfWords];//array of token to store all the tokens.
					boolean flag[] = new boolean[numOfWords];//Flag for encountered keywords
					for (int i = 0; i < numOfWords; i++)
						flag[i] = true;
					boolean isColored[] = new boolean[numOfWords];// to color keywords with red.
					int i = 0;

					while (st.hasMoreTokens()) {
						a[i] = st.nextToken();// to fill the token array.
						i++;
					}

					int windowStart, windowEnd; //windows used to implement ngram logic.
					String questionSubstring, concept;
					i1 = 0;
					int pos[] = new int[1000];
					for (i1 = 0; i1 < 10; i1++)
						pos[i1] = -1;
					i1 = 0;
					System.out.println("\n\nQuestion: " + str[z]);

					for (int windowSize = numOfWords; windowSize > 0; windowSize--) {
						//System.out.println("Window size: "+windowSize);
						windowStart = 0;
						windowEnd = windowSize;
						//start of ngram logic
						do {
							questionSubstring = "";
							//System.out.println("Start: "+windowStart+", End: "+windowEnd);
							int pointer = 0;
							for (pointer = windowStart; (pointer < windowEnd) && (flag[pointer] != false); pointer++)
								questionSubstring = questionSubstring.concat((" " + a[pointer])).trim();
							//System.out.println(questionSubstring);
							for (i = 0; i < m.totalAnnotationCount; i++) {
								concept = m.conceptList[i].keyword;

								if (concept.equalsIgnoreCase(questionSubstring)) {
									for (pointer = windowStart; pointer < windowEnd; pointer++) {
										flag[pointer] = false;
										isColored[pointer] = true;

									}
									concepts[noOfNodesMapped] = questionSubstring;
									nodesMapped[noOfNodesMapped] = m.conceptList[i].associatedNode;
									noOfNodesMapped++;
									pos[i1++] = i;
								}
							}
							windowStart++;
							windowEnd++;

						} while (windowEnd <= numOfWords);
					}

					Q[z][z1].nodesMapped = new NodeCapsule[noOfNodesMapped];
					Q[z][z1].test = new NodeCapsule[noOfNodesMapped];
					Q[z][z1].concepts = new String[noOfNodesMapped];
					//q.question = new String[numOfWords];
					Q[z][z1].question = questionPaper[z1];
					//q.marks = marks;
					Q[z][z1].noOfNodesMapped = noOfNodesMapped;
					for (i = 0; i < noOfNodesMapped; i++) {
						Q[z][z1].concepts[i] = concepts[i];
						Q[z][z1].nodesMapped[i] = nodesMapped[i];
						Q[z][z1].test[i] = nodesMapped[i];
					}
					Q[z][z1].checkAncestors(m);

					MappedNodes2[z1] = Q[z][z1].propogate(m);

					count[z][z1] = Q[z][z1].Mapcount;
					for (i = 0; i < count[z][z1]; i++)
						System.out.print("For Question 2, Question :" + z1 + MappedNodes2[z1][i].name + " ");
					System.out.println();

					z1++;
				}
				z++;
			}

		}
	%>
	<center>
		<table border=2 cellspacing=1 cellpadding=2>
			<tr>
				<th>Formula</th>
				<th>Simlarity percentage</th>
			</tr>
			<tr>
				<td>First</td>
				<td bgcolor="blue"></td>
			</tr>
			<tr>
				<td>Second</td>
				<td bgcolor="red"></td>
			</tr>
			<tr>
				<td>Third</td>
				<td bgcolor="green"></td>
			</tr>
			<tr>
				<td>Fourth</td>
				<td bgcolor="orange"></td>
			</tr>
		</table>
	</center>
	<%
		float sim[][][] = new float[100][100][4];

		//out.println("<font >Similarity Matrix using Formula one the selected question papers</font>");

		out.println("<table STYLE=\"position:absolute; TOP:200px; LEFT:10px;\" cellspacing=4 cellpadding=1 border=1>");
		out.println("<tr>");

		//out.println("<td <center><font face=\"impact\" size=3>Similarity</font></td>");

		out.println("</tr>");

		out.println("<tr>");
		out.println("<td width:50px> <center><font size=3>Questions From Paper 1|Question From Paper2 </font> </center></td>");
		for (int j = 0; j < numOfQuestions[1]; j++) {
			out.println("<td width:50px> <center><font size=3>" + Q[1][j].question + " </font> </center></td>");
		}
		out.println("</tr>");

		for (int i = 0; i < numOfQuestions[0]; i++) {
			out.println("<tr>");
			out.println("<td width=20px> <center><font size=3>" + Q[0][i].question + " </font> </center></td>");
			for (int j = 0; j < numOfQuestions[1]; j++) {
				NodeCapsule a[] = new NodeCapsule[count[0][i]];
				for (int k1 = 0; k1 < count[0][i]; k1++)
					a[k1] = MappedNodes1[i][k1];
				NodeCapsule b[] = new NodeCapsule[count[1][j]];
				for (int k2 = 0; k2 < count[1][j]; k2++)
					b[k2] = MappedNodes2[j][k2];

				sim[i][j] = Q[0][i].similarity(a, b);

				out.println("<td width:20px><font size=3>"

				+ "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=2>" + "<TR><TD>&nbsp;</TD><TD valign=left>"
						+ "<TABLE><TR><TD bgcolor=blue><IMG SRC='/gifs/s.gif' width="
						+ sim[i][j][0] * 200
						+ " height=0></TD>"
						+ "<TD><FONT SIZE=3>"
						+ sim[i][j][0] * 100
						+ "</FONT></TD></TR>"
						+ "</TABLE></TD></TR>"
						+ "</TD></TR>"
						+ "<TR><TD>&nbsp;</TD><TD valign=left>"
						+ "<TABLE><TR><TD bgcolor=red><IMG SRC='/gifs/s.gif' width="
						+ sim[i][j][1] * 200
						+ " height=0></TD>"
						+ "<TD><FONT SIZE=3>"
						+ sim[i][j][1] * 100
						+ "</FONT></TD></TR>"
						+ "</TABLE></TD></TR>"
						+ "</TD></TR>"
						+ "<TR><TD>&nbsp;</TD><TD valign=left>"
						+ "<TABLE><TR><TD bgcolor=green><IMG SRC='/gifs/s.gif' width="
						+ sim[i][j][2] * 200
						+ " height=0></TD>"
						+ "<TD><FONT SIZE=3>"
						+ sim[i][j][2]
						* 100
						+ "</FONT></TD></TR>"
						+ "</TABLE></TD></TR>"
						+ "</TD></TR>"
						+ "<TR><TD>&nbsp;</TD><TD valign=left>"
						+ "<TABLE><TR><TD bgcolor=orange><IMG SRC='/gifs/s.gif' width="
						+ sim[i][j][3]
						* 200
						+ " height=0></TD>"
						+ "<TD><FONT SIZE=3>"
						+ sim[i][j][3]
						* 100
						+ "</FONT></TD></TR>"
						+ "</TABLE></TD></TR>"
						+ "</TD></TR>"
						+ "</TABLE></font> </td>");
			}
			out.println("</tr>");
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>