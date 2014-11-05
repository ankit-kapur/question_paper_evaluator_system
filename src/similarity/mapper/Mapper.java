package similarity.mapper;

import java.io.File;
import java.util.StringTokenizer;

import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.AddAxiom;
import org.semanticweb.owlapi.model.AddOntologyAnnotation;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLAnnotation;
import org.semanticweb.owlapi.model.OWLAnnotationProperty;
import org.semanticweb.owlapi.model.OWLAxiom;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLLiteral;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.model.OWLOntologyCreationException;
import org.semanticweb.owlapi.model.OWLOntologyManager;
import org.semanticweb.owlapi.vocab.OWLRDFVocabulary;

public class Mapper
{
    public NodeCapsule node[];
    public ConceptCapsule conceptList[];

    public NodeCapsule root;
    public String fileName; //address of OWL file.
    public int totalAnnotationCount;
    public int rootPos;
    public String rootIndex;
    public int numOfNodes;

    public Mapper(String s)
    {
        fileName = s;
        numOfNodes=0;
    }

    public boolean isAncestor(NodeCapsule n1, NodeCapsule n2)
    {
        NodeCapsule x = n2;

//for(int i=0; i<numOfNodes; i++)
//    System.out.println(i+"  Name: "+node[i].name + "   Parent: "+node[i].parentName);
        while(x!=root)
        {
           // System.out.print(x.name + " -> ");
            x = x.parent;

            if(x==n1)
            {
                //System.out.println(n1.name + "   "+ x.name);
                return true;
            }
        }
        return false;
    }

    public void displayAll()
    {
        for(int i=0; i<numOfNodes; i++)
            node[i].displayDetails();
  /*      System.out.println ("\n\nConcepts:\n");

        for(int i=0; i<totalAnnotationCount; i++)
        {
            if(conceptList[i]!=null)
              System.out.println (i+"  "+conceptList[i].keyword + " <-- " + conceptList[i].associatedNode.name);
        }
        System.out.println ("Total:"+totalAnnotationCount);
   */
    }

    public void ReadOntology()
    {
        try {
            // Create our manager
            OWLOntologyManager man = OWLManager.createOWLOntologyManager();

            // Load the ontology
           File file = new File(fileName);

           // Now load the local copy
            OWLOntology ont = man.loadOntologyFromOntologyDocument(file);
           System.out.println("Loaded ontology: " + ont);

           IRI documentIRI = man.getOntologyDocumentIRI(ont);
           System.out.println("    from: " + documentIRI);

            // We want to add a comment to the pizza class.
            // First, we need to obtain a reference to the pizza class
            OWLDataFactory df = man.getOWLDataFactory();
            OWLClass pizzaCls = df.getOWLClass(IRI.create(ont.getOntologyID().getOntologyIRI().toString() + "#Pizza"));

            // Now we create the content of our comment.  In this case we simply want a plain string literal.
            // We'll attach a language to the comment to specify that our comment is written in English (en).
            OWLAnnotation commentAnno = df.getOWLAnnotation(
                    df.getOWLAnnotationProperty(OWLRDFVocabulary.RDFS_COMMENT.getIRI()),
                    df.getOWLLiteral("A class which represents pizzas", "en"));

            // Specify that the pizza class has an annotation - to do this we attach an entity annotation using
            // an entity annotation axiom (remember, classes are entities)
            OWLAxiom ax = df.getOWLAnnotationAssertionAxiom(pizzaCls.getIRI(), commentAnno);

            // Add the axiom to the ontology
            man.applyChange(new AddAxiom(ont, ax));

            // Now lets add a version info annotation to the ontology.  There is no 'standard' OWL 1.1 annotation
            // object for this, like there is for comments and labels, so the creation of the annotation is a bit
            // more involved.
            // First we'll create a constant for the annotation value.  Version info should probably contain a
            // version number for the ontology, but in this case, we'll add some text to describe why the version
            // has been updated
            OWLLiteral lit = df.getOWLLiteral("Added a comment to the pizza class");
            // The above constant is just a plain literal containing the version info text/comment
            // we need to create an annotation, which pairs a URI with the constant
            OWLAnnotation anno = df.getOWLAnnotation(df.getOWLAnnotationProperty(OWLRDFVocabulary.OWL_VERSION_INFO.getIRI()), lit);
            // Now we can add this as an ontology annotation
            // Apply the change in the usual way
            man.applyChange(new AddOntologyAnnotation(ont, anno));
            // Firstly, get the annotation property for rdfs:label
            OWLAnnotationProperty comment = df.getOWLAnnotationProperty(OWLRDFVocabulary.RDFS_COMMENT.getIRI());


            totalAnnotationCount = 0;
            rootPos=0;
            String index[]=new String[100];
            int level[]=new int[100];
            int r1[] = new int[100]; //r1 lower range, r2 higher range.
            int r2[] = new int[100];
            String parent[] = new String[100];
            String concept[]=new String[100];
            String subclasses[][] = new String[100][20];
            String annotations[][] = new String[100][20];
            int numOfAnnotations[] = new int[100];
            int numOfSubclasses[] = new int[100];
            int count=0;
            int n=0;

            for(int i=0; i<100;i++)
                numOfAnnotations[i] = numOfSubclasses[i] = 0;

            for (OWLClass cls : ont.getClassesInSignature()) //gets all the nodes  from owl file
            {

                   //store
                   String g=cls.toStringID();
                   int i=g.indexOf(".owl");
                   if(i!= -1)
                             g = g.substring(i+5, g.length());
                   g = g.replace('_',' ');   // To remove underscores

                   /* If the root node is encountered*/
                   i=g.indexOf("owl#Thing");
                   if(i!= -1)
                   {
                             g="Root";
                             rootPos=n;
                   }

                   concept[n]=g.trim();

                   //parent
                   OWLClass c=cls;
                   //parent[n] = removeExtra(c.getSuperClasses(ont).toString()).replace('_',' ').trim();
                   parent[n] = (c.getSuperClasses(ont).toString()).replace('_',' ').replace('[',' ').replace(']',' ');
                   i=parent[n].indexOf(".owl");
                   if(i!= -1)
                             parent[n] = parent[n].substring(i+5, parent[n].length()-2);

                   i=parent[n].indexOf("owl:"); /* For ROOT (Thing) node */
                   if(i!= -1)
                             parent[n] = "Root";
                   parent[n] = parent[n].trim();

                   // To get subclasses
                   String temp = c.getSubClasses(ont).toString();
                   int len=temp.length();
                   temp=temp.replace(']',' ').replace('[',' ').replace('>',' ').trim();
                   StringTokenizer stok = new StringTokenizer(temp, ",");
                   numOfSubclasses[n] = stok.countTokens();
                   int w=0;
                   while(stok.hasMoreTokens())
                    {
                        temp = stok.nextToken()+".";
                        temp.replace('[', ' ');
                        i=temp.indexOf(".owl");
                        if(i!= -1)
                            temp =temp.substring(i+5, temp.length()-1);
                        
                        subclasses[n][w] = temp.trim().replace('_',' ').replace('[', ' ').trim();
                        w++;
                    }

                for (OWLAnnotation annotation : cls.getAnnotations(ont, comment))
                {
                if (annotation.getValue() instanceof OWLLiteral) {
                OWLLiteral val = (OWLLiteral) annotation.getValue();

                String tem=val.getLiteral();

                StringTokenizer st = new StringTokenizer(tem, ",");
                index[n] = st.nextToken();
                level[n]=Integer.parseInt(st.nextToken().trim());
                r1[n] = Integer.parseInt(st.nextToken().trim());
                r2[n] = Integer.parseInt(st.nextToken().trim());
                numOfAnnotations[n] = st.countTokens();
                w=0;
                while(st.hasMoreTokens())
                {
                    annotations[n][w] = st.nextToken().trim();
                    w++;
                    totalAnnotationCount++;
                }
               }
              }  // end of annotation traversal

                n++;
            }
            numOfNodes = n;

            rootIndex = index[rootPos];

            /* Creation of Node objects */
            node = new NodeCapsule[n];
            totalAnnotationCount += (numOfNodes);
            conceptList = new ConceptCapsule[totalAnnotationCount];
            int annoCount=0;
            for (int i=0;i<n;i++)
            {
                node[i] = new NodeCapsule(concept[i], index[i],level[i], r1[i], r2[i], numOfAnnotations[i], annotations[i], parent[i], numOfSubclasses[i], subclasses[i]);
                for(int j=0; j<numOfAnnotations[i]; j++)
                {
//System.out.println("Anno: "+annotations[i][j]+", Node: "+node[i].name+", i="+i+", j="+j);
                    if(!node[i].name.equalsIgnoreCase(annotations[i][j]))
                    {
                        conceptList[annoCount] = new ConceptCapsule(annotations[i][j], node[i]);
                        annoCount++;
//System.out.println(annoCount+"  Anno: "+annotations[i][j]+ "   "+node[i]);
                    }
                }

                //adding the nodes themselves to the conceptlist

                if(node[i]!=null)
                {
                    conceptList[annoCount] = new ConceptCapsule(node[i].name, node[i]);
                    annoCount++;
                }
//System.out.println(annoCount+"  Nodename: "+node[i].name+ "   "+node[i]);
            }
            totalAnnotationCount=annoCount;


            /* Finding ROOT */
            for(int i=0; i<numOfNodes; i++)
            {
                if((node[i].name.equalsIgnoreCase("Root")))
                {
                    node[i].parent = null;
                    root = node[i];         // Root found
                    break;
                }

            }

            establishLinks(root, "");  // starting from the Root node
        }
        catch (OWLOntologyCreationException e) {
            System.out.println("Could not create ontology");
        }
    }

        String removeExtra(String g)
        {
           int i=g.indexOf(".owl");
           if(i!= -1)
                g=g.substring(i+5, g.length()-1);
            return g;
        }




        void establishLinks(NodeCapsule current, String tabs)
        {
            if(current.numOfSubclasses <=0)
                return;
            
            for(int x=0; x<current.numOfSubclasses; x++)
            {
                //System.out.print("  "+current.subclassesName[x]);
                for(int y=0; y<numOfNodes; y++)
                {
                    if((node[y].name).equals(current.subclassesName[x]))
                    {                        
                        current.subclasses[x] = node[y];
                        node[y].parent = current;                     

     /* 
                System.out.println("\nCurrent:  "+ current.name+ "   No. of subclasses : "+current.numOfSubclasses);
                        if(current.parent != null)
                            System.out.println("   Parent -> "+current.parent.name);
                        System.out.println("   Child: "+current.subclasses[x].name);
    */
                        establishLinks(node[y], tabs+= "    ");
        }
                }
            }
        }
}