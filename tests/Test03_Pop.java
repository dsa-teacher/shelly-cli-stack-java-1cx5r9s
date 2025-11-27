import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class Test03_Pop {
    @Test
    public void testPop() {
        Stack<Integer> stack = new Stack<>();
        stack.push(10);
        stack.push(20);
        assertEquals(20, stack.pop(), "Pop should return 20");
        assertEquals(1, stack.size(), "Size should be 1 after pop");
        assertEquals(10, stack.pop(), "Pop should return 10");
        assertEquals(0, stack.size(), "Size should be 0 after second pop");
    }

    @Test
    public void testPopEmpty() {
        Stack<Integer> stack = new Stack<>();
        assertNull(stack.pop(), "Pop on empty stack should return null");
    }
}
