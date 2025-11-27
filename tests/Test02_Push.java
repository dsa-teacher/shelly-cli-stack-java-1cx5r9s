import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class Test02_Push {
    @Test
    public void testPush() {
        Stack<Integer> stack = new Stack<>();
        assertDoesNotThrow(() -> stack.push(10), "Push should not throw");
        assertDoesNotThrow(() -> stack.push(20), "Push should handle multiple calls");
    }
}

