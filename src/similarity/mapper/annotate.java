package similarity.mapper;

public class annotate
{
    public static void main(String[] args)
    {
        Mapper m = new Mapper("D:\\Implementation\\data/DMver1.owl");
        m.ReadOntology();

        NodeCapsule x = m.node[0];

        System.out.println("\n\n"+m.isAncestor(m.root, x));


       while(x!=m.root)
        {
            System.out.print(x.name + " -> ");
            x = x.parent;
            
            if(x==m.root)
                System.out.println(x.name);
        }

        for(int y=0; y<m.numOfNodes; y++)
        {
            NodeCapsule current = m.node[y];
                        System.out.println("\nCurrent:  "+ current.name);
                        if(current.parent != null)
                            System.out.println("   Parent -> "+current.parent.name);
            for(int x1=0; x1<current.numOfSubclasses; x1++)
            {
                System.out.println("   Child no. "+(x1+1)+" : "+current.subclasses[x1].name);
                        
            }
        }

        //m.displayAll();

        //System.out.println("\n\n\n"+m.rootIndex);

    }
}