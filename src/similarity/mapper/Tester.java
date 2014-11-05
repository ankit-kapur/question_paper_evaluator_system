package similarity.mapper;

import java.util.*;

public class Tester {
	
	public static void main(String[] args) {
		Question q = new Question();
		Mapper m = new Mapper("C:/Users/sony/Downloads/DataMining.owl");
		m.ReadOntology();
		
		String str = "What is measuring performance in k-means clustering and in classification?";
		int marks = 0;
		int noOfNodesMapped = 0;
		NodeCapsule nodesMapped[] = new NodeCapsule[100];
		String concepts[] = new String[100];

		StringTokenizer st = new StringTokenizer(str, "?., ");
		int numOfWords = st.countTokens();
		String a[] = new String[numOfWords];
		boolean isColored[] = new boolean[numOfWords];
		int i = 0;

		while (st.hasMoreTokens()) {
			a[i] = st.nextToken();
			i++;
		}

		int windowStart, windowEnd;
		String questionSubstring, concept;

		System.out.println("\n\nQuestion: " + str);

		for (int windowSize = numOfWords; windowSize > 0; windowSize--) {
			// System.out.println("Window size: "+windowSize);
			windowStart = 0;
			windowEnd = windowSize;

			do {
				questionSubstring = "";
				// System.out.println("Start: "+windowStart+", End: "+windowEnd);
				int pointer = 0;
				for (pointer = windowStart; pointer < windowEnd; pointer++)
					questionSubstring = questionSubstring.concat((" " + a[pointer])).trim();
				// System.out.println(questionSubstring);
				for (i = 0; i < m.totalAnnotationCount; i++) {
					concept = m.conceptList[i].keyword;

					if (concept.equalsIgnoreCase(questionSubstring)) {
						for (pointer = windowStart; pointer < windowEnd; pointer++) {
							isColored[pointer] = true;

						}
						concepts[noOfNodesMapped] = questionSubstring;
						nodesMapped[noOfNodesMapped] = m.conceptList[i].associatedNode;
						noOfNodesMapped++;
					}
				}
				windowStart++;
				windowEnd++;

			} while (windowEnd <= numOfWords);
		}

		q.nodesMapped = new NodeCapsule[noOfNodesMapped];
		q.concepts = new String[noOfNodesMapped];
		// q.question = new String[numOfWords];
		// q.question = a;
		q.marks = marks;
		q.noOfNodesMapped = noOfNodesMapped;
		for (i = 0; i < noOfNodesMapped; i++) {
			q.concepts[i] = concepts[i];
			q.nodesMapped[i] = nodesMapped[i];
		}
		// q.checkAncestors(m);

		m.displayAll();

		System.out.println("noOfNodesMapped: " + noOfNodesMapped);
		for (i = 0; i < noOfNodesMapped; i++)
			System.out.println(nodesMapped[i].name);
		System.out.println();

		q.ancestor = new NodeCapsule[noOfNodesMapped];
		for (i = 0; i < noOfNodesMapped; i++) {
			System.out.println("Checking: " + q.nodesMapped[i].name);
			q.ancestor[i] = null;
			for (int j = 0; j < q.noOfNodesMapped; j++) {
				if (i != j) {
					System.out.println("\tWith: " + q.nodesMapped[j].name);
					if (m.isAncestor(q.nodesMapped[i], q.nodesMapped[j])) {
						q.ancestor[i] = q.nodesMapped[j];
						System.out.println("- " + q.nodesMapped[j].name + "    is an Ancestor of " + q.nodesMapped[j].name);
					}
				}
			}
		}

		for (i = 0; i < q.noOfNodesMapped; i++) {
			System.out.println("Child node : " + q.nodesMapped[i].name);
			System.out.println("Ancestor: " + q.ancestor[i].name);

		}

	}
}
