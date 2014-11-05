package similarity.mapper;

public class NodeCapsule
{
     public String name;
     public String identity;
     public int level;
     public int LowerRange, UpperRange;
     public int numOfAnnotations;
     public String annotations[];
     public String parentName;
     public int numOfSubclasses;
     public String subclassesName[];


     public NodeCapsule parent;
     public NodeCapsule subclasses[];  //array of pointers to the child nodes. size is dynamic=numOfSubclasses

     NodeCapsule(String _name, String _identity,int _level, int _LowerRange, int _UpperRange, int _numOfAnnotations, String _annotations[], String _parentName, int _numOfSubclasses, String _subclassesName[])
     {
        name = _name;
        identity = _identity;
        level=_level;
        LowerRange = _LowerRange;
        UpperRange = _UpperRange;
        numOfAnnotations = _numOfAnnotations;
        annotations = _annotations;
        parentName = _parentName;
        numOfSubclasses = _numOfSubclasses;
        subclassesName = _subclassesName;

        subclasses = new NodeCapsule[numOfSubclasses]; //numOfSubclasses is found using some func and passed into the constructor
        parent = null;
        for(int i=0; i<numOfSubclasses; i++)
            subclasses[i]=null;
     }

     void displayDetails()
     {
        System.out.println("\n\n________");
        System.out.println("Name: "+name);
        System.out.println("Identity: "+identity);
        System.out.println("Level: "+level);
        System.out.println("Lower range: "+LowerRange);
        System.out.println("Upper range: "+UpperRange);
        System.out.println("Number of annotations: "+numOfAnnotations);
        System.out.print("Annotations: ");
        for(int i=0; i<numOfAnnotations; i++)
        {
            System.out.print(annotations[i]);
            if(i!=numOfAnnotations-1)
                System.out.print(", ");
        }
        System.out.println("\nNumber of subclasses: "+numOfSubclasses);
        System.out.println("- - - - -");
        if(parent!=null)
            System.out.println("Parent node: "+parent.name);
        else
            System.out.println("Parent node: None");
        System.out.println("Subclasses: ");
        for(int i=0; i<numOfSubclasses; i++)
        {
            if(subclasses[i]!=null)
                System.out.print(subclasses[i].name);
            if(i!=numOfSubclasses-1)
                System.out.print(", ");
        }
     }
}