public class Node
{
    public String token;
    public Node left;
    public Node right;

    public Node(String token) {
        this.token=token;
    }

    public Node() {
    }

    public String toString() {
        return "Node: "+token;
    }


}
