```markdown
# backup-25may20260951pm Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches the core development patterns and conventions used in the `backup-25may20260951pm` TypeScript codebase. It covers file organization, import/export styles, commit message habits, and testing approaches. The repository is framework-agnostic and emphasizes clarity and consistency in code structure.

## Coding Conventions

### File Naming
- **Style:** Kebab-case (all lowercase, words separated by hyphens)
- **Example:**  
  ```
  user-service.ts
  backup-handler.ts
  data-model.test.ts
  ```

### Import Style
- **Style:** Relative imports are used throughout the codebase.
- **Example:**
  ```typescript
  import { fetchData } from './utils/fetch-data';
  import { User } from '../models/user';
  ```

### Export Style
- **Style:** Named exports are preferred.
- **Example:**
  ```typescript
  // In user-service.ts
  export function createUser() { ... }
  export const USER_ROLE = 'admin';
  ```

### Commit Messages
- **Pattern:** Freeform, no strict prefixes, average length ~38 characters.
- **Example:**
  ```
  add backup handler for user data
  fix typo in data-model
  update fetch logic for performance
  ```

## Workflows

### Creating a New Module
**Trigger:** When adding a new feature or logical unit.
**Command:** `/create-module`

1. Create a new file using kebab-case naming (e.g., `feature-name.ts`).
2. Use relative imports for dependencies.
3. Export all public functions or constants using named exports.
4. If applicable, create a corresponding test file (e.g., `feature-name.test.ts`).

### Writing and Running Tests
**Trigger:** When verifying code correctness.
**Command:** `/run-tests`

1. Create a test file with the `.test.` pattern (e.g., `user-service.test.ts`).
2. Write tests using your preferred framework (framework is not enforced).
3. Run the test suite using the project's test runner (refer to project documentation or scripts).

### Refactoring Existing Code
**Trigger:** When improving or restructuring code.
**Command:** `/refactor`

1. Update file names to kebab-case if needed.
2. Ensure all imports remain relative after moving files.
3. Use named exports for all modules.
4. Update or add tests as necessary.

## Testing Patterns

- **Test File Naming:**  
  Test files follow the `*.test.*` pattern, typically placed alongside the code they test.
  ```
  data-model.test.ts
  backup-handler.test.ts
  ```
- **Framework:**  
  No specific testing framework detected; use your preferred TypeScript-compatible testing tool.
- **Example Test Skeleton:**
  ```typescript
  // In backup-handler.test.ts
  import { backupHandler } from './backup-handler';

  describe('backupHandler', () => {
    it('should process data correctly', () => {
      // test implementation
    });
  });
  ```

## Commands
| Command         | Purpose                                      |
|-----------------|----------------------------------------------|
| /create-module  | Scaffold a new module with proper conventions|
| /run-tests      | Run all test files in the project            |
| /refactor       | Refactor code to align with conventions      |
```
