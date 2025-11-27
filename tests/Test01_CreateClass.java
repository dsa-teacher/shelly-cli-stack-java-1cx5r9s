import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;

public class Test01_CreateClass {
    @Test
    public void testCreateStack() {
        // Verify Stack class can be instantiated
        Stack<Integer> stack = new Stack<>();
        assertNotNull(stack, "Stack should not be null");
        
        // Verify that Stack class has an internal storage field (array or list)
        // This ensures the user actually wrote code to initialize the storage
        Class<?> stackClass = stack.getClass();
        Field[] fields = stackClass.getDeclaredFields();
        
        boolean hasStorageField = false;
        for (Field field : fields) {
            String fieldName = field.getName().toLowerCase();
            Class<?> fieldType = field.getType();
            
            // Check if it's an array or List (internal storage)
            if ((fieldType.isArray() || 
                 java.util.List.class.isAssignableFrom(fieldType) ||
                 java.util.ArrayList.class.isAssignableFrom(fieldType)) &&
                (fieldName.contains("item") || fieldName.contains("element") || 
                 fieldName.contains("data") || fieldName.contains("storage"))) {
                hasStorageField = true;
                
                // Verify the field is initialized (not null)
                try {
                    field.setAccessible(true);
                    Object value = field.get(stack);
                    assertNotNull(value, "Internal storage field should be initialized in constructor");
                } catch (IllegalAccessException e) {
                    fail("Could not access storage field: " + e.getMessage());
                }
                break;
            }
        }
        
        assertTrue(hasStorageField, 
            "Stack class must have an internal storage field (array or List) initialized in the constructor");
    }
}
