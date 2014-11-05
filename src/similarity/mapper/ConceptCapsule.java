package similarity.mapper;

public class ConceptCapsule //pointer to node structure
 {
     public String keyword;
     public NodeCapsule associatedNode;

     ConceptCapsule(String _keyword, NodeCapsule _associatedNode)
     {
         keyword = _keyword;
         associatedNode = _associatedNode;
     }
 }
