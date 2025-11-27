import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class Test05_Size {
    @Test
    public void testSize() {
        Stack<Integer> stack = new Stack<>();
        assertEquals(0, stack.size(), "Initial size should be 0");
        stack.push(10);
        assertEquals(1, stack.size(), "Size should be 1 after push");
        stack.push(20);
        assertEquals(2, stack.size(), "Size should be 2 after second push");
        stack.pop();
        assertEquals(1, stack.size(), "Size should be 1 after pop");
    }
}

