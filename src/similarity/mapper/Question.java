package similarity.mapper;
import java.applet.Applet;

public class Question extends Applet
{
  	private static final long serialVersionUID = -2087389385372234320L;
	public String question;
    public String question1[];
    public int marks;
    public int noOfNodesMapped;
    public NodeCapsule nodesMapped[];//size depends on number of keywords found in the question
    public NodeCapsule test[];
    public String concepts[]; // keywords found using ngrams logic
    public NodeCapsule ancestor[];
    public int Mapcount=0;

    public void checkAncestors(Mapper m)
    {
        ancestor = new NodeCapsule[noOfNodesMapped];
        for(int i=0; i<noOfNodesMapped; i++)
        {
            ancestor[i] = null;
            for(int j=0; j<noOfNodesMapped; j++)
            {
                if(i!=j)
                {
                    if(m.isAncestor(nodesMapped[i], nodesMapped[j]))
                            ancestor[j] = nodesMapped[i];
                }
            }
        }

    }
 public NodeCapsule[] propogate(Mapper m)
 {

    boolean flag=true;
    NodeCapsule temp[]=new NodeCapsule[100];
    int i=0;
    for( i=0;i<noOfNodesMapped;i++)
     {
         
        while(!(test[i]==null))
         {

            flag=true;
            for(int j=0;j<Mapcount;j++)
           {
               if (test[i].name.equalsIgnoreCase(temp[j].name))
               {
                    flag=false;
                    break ;
               }
            }
            if(flag==true)
            {
                temp[Mapcount++] = test[i];
                
            }
            test[i]=test[i].parent;

         }
     }
   
     
     return temp;
 }

 public float[] similarity(NodeCapsule a1[],NodeCapsule a2[])
    {
    int count=0;
    int count1=0;
    a1=bubblesort(a1);
    a2=bubblesort(a2);

   

    for(int i=0;i<a1.length;i++)
    inner: for(int j=0;j<a2.length;j++)
     {
         if(a1[i].name.equalsIgnoreCase(a2[j].name))
         {
             count++;
             count1=count1+a1[i].level;
             break inner;
         }
     }
    
    System.out.println("Number of strings common is:\t"+count);
    double m1=a1.length-count;
    double m2=a2.length-count;
    double m11=0;
    double m12=0;
    double m21=0;
    double m22=0;
    for(int i=0;i<a1.length;i++)
       m11+=a1[i].level;
    for(int i=0;i<a2.length;i++)
       m12+=a2[i].level;

    m21=m11-count1;
    m22=m12-count1;

    double alpha=0.5;
    double beta=0.5;
    float sim[]=new float[4];
    sim[0]=(float)count/(float)(count+(alpha*m1)+(beta*m2));
    sim[1]=(float)count1/(float)(count1+(alpha*m21)+(beta*m22));
    double num1=((float)(count1/(float)m11)+(float)(count1/(float)m12));
    sim[2]=(float)(num1)/((float)(num1+alpha*(m21/(float)m11)+beta*((float)m22/m12)));
    double num2=((float)(count1/(float)Math.max(m11,m12))+(float)(count1/(float)Math.max(m11,m12)));
    sim[3]=(float)num2/((float)(num2+alpha*(m21/Math.max((float)m11,(float)m12)) +beta*(m22/Math.max((float)m11,(float)m12))));

    System.out.println("Variable count :"+count1);
     return sim;
    }

NodeCapsule[] bubblesort(NodeCapsule a[])
    {
    NodeCapsule temp;
    for(int x=0;x<a.length;x++)
		{
		for(int y=1;y<a.length-x;y++)
			{
			if(a[y-1].name.compareTo(a[y].name)>0)
				{
				temp=a[y-1];
				a[y-1]=a[y];
				a[y]=temp;

				}
			}
		}
    return a;
    }
//void plotgraph()
    {
    }
}
