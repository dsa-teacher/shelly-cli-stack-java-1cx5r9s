import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class Test04_Peek {
    @Test
    public void testPeek() {
        Stack<Integer> stack = new Stack<>();
        stack.push(10);
        stack.push(20);
        assertEquals(20, stack.peek(), "Peek should return 20");
        assertEquals(2, stack.size(), "Size should remain 2 after peek");
    }

    @Test
    public void testPeekEmpty() {
        Stack<Integer> stack = new Stack<>();
        assertNull(stack.peek(), "Peek on empty stack should return null");
    }
}
