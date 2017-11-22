public class Node {
    public String token;
    public Node left;
    public Node right;
    public String type;

    public Node(String token) {
        this.token = token;
    }

    public Node(String token, String type) {
        this.token = token;
        this.type = type;
    }

    public Node() {
    }

    public String toString() {
        return "Node: " + token + ", type:" + type ;
    }


}
