def safe_divide(a, b):
    """
    Handles ZeroDivisionError and TypeError separately.
    Always prints "Operation complete." in finally block.
    """
    try:
        result = a / b
        print(f"Result: {result}")
        return result
    except ZeroDivisionError:
        print("Error: Cannot divide by zero!")
    except TypeError:
        print("Error: Invalid operand types for division!")
    finally:
        print("Operation complete.")


class UsernameTooShortError(Exception):
    """Raised when username is less than 4 characters."""
    pass


class WeakPasswordError(Exception):
    """Raised when password is less than 8 characters or contains no digit."""
    pass


def register(username, password):
    """
    Validates username and password, raising appropriate exceptions.
    
    Args:
        username: Must be at least 4 characters
        password: Must be at least 8 characters and contain at least 1 digit
    
    Raises:
        UsernameTooShortError: If username < 4 chars
        WeakPasswordError: If password < 8 chars or has no digit
    """
    
    if len(username) < 4:
        raise UsernameTooShortError(f"Username '{username}' is too short! Must be at least 4 characters.")
    
    if len(password) < 8:
        raise WeakPasswordError(f"Password is too weak! Must be at least 8 characters.")
    
    if not any(char.isdigit() for char in password):
        raise WeakPasswordError(f"Password is too weak! Must contain at least one digit.")
    
       
safe_divide(10, 2)
safe_divide(5, 0)
safe_divide("x", 3)

try:
        register('john123', 'secure123')
except (UsernameTooShortError, WeakPasswordError) as e:
        print(f"✗ Registration failed: {e}")
    

try:
        register('joe', 'secure123')
except (UsernameTooShortError, WeakPasswordError) as e:
        print(f"✗ Registration failed: {e}")
    
try:
        register('alice', 'short1')
except (UsernameTooShortError, WeakPasswordError) as e:
        print(f"✗ Registration failed: {e}")
    
try:
        register('bob123', 'nosecurityhere')
except (UsernameTooShortError, WeakPasswordError) as e:
    print(f"✗ Registration failed: {e}")
    
    
try:
        register('sarah2024', 'password99')
except (UsernameTooShortError, WeakPasswordError) as e:
        print(f"✗ Registration failed: {e}")
    

   