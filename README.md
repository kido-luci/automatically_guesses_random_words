# README

## **Overview**

This project is designed to guess a word programmatically based on the rules of a Wordle-like puzzle. It uses a combination of logic and AI tools to generate words that fit specific constraints and conditions derived from previous guesses and results.

---

## **Project Setup**

**Create a `.env` File:**  
Inside the project directory, create a file named `.env` and add the following:

```env
OPENAI_API_KEY=your_openai_api_key_here
```

Replace `your_openai_api_key_here` with your actual OpenAI API key.

---

## **Functionality**

### **Method Purpose**

`getGuessesWord` generates a valid word guess based on:

- Word length.
- Previously guessed words and their feedback.
- Specific inclusion or exclusion rules for letters and their positions.

### **Inputs**

- **`wordLength`**: An integer specifying the required length of the word.
- **`lines`**: A map where:
  - The key is an integer representing the attempt number.
  - The value is a list of `GuessWord` objects, each containing:
    - **`guess`**: A letter guessed in the current attempt.
    - **`result`**: The result of the guess (`correct`, `present`, `absent`).

### **Outputs**

- **`String?`**: The next word guess or `null` if no valid guess can be determined.

---

## **Key Logic**

### **1. Initial Setup**

- Creates a map of `_GuestLetter` objects for each letter position in the word, which tracks possible letters (`letter`) and restricted letters (`excepts`).
- Sets up three sets to track constraints:
  - **`mustContains`**: Letters that must be in the word.
  - **`notContains`**: Letters that cannot be in the word.
  - **`wasGuesses`**: Full words already guessed.

---

### **2. Handling Input Data**

- **No Data (`lines.isEmpty`)**:  
  Generates a random word using a prompt to the OpenAI API.
- **With Data (`lines.isNotEmpty`)**:
  - Processes each line to determine feedback about previous guesses:
    - **Correct Letter**: Assigns it to the appropriate index.
    - **Present Letter**: Ensures the letter is included but excludes it from specific positions.
    - **Absent Letter**: Adds the letter to the exclusion list.
  - Constructs detailed rules based on the constraints for the AI prompt.

---

### **3. AI Integration**

- Generates a structured prompt with constraints, e.g.:
  - The word must contain specific letters.
  - Certain letters are restricted at specific positions.
- Sends the prompt to OpenAI to retrieve a valid word.

---

### **4. Validation**

- Ensures the returned word meets the required length.
- Prevents duplicate guesses by checking against previous guesses.

---

## **Error Handling**

- Throws exceptions for:
  - Words that do not match the specified length.
  - Duplicate guesses matching the most recent attempt.

---

## **Dependencies**

- **`OpenAiUtilities`**: For sending prompts to OpenAI and retrieving responses.
- **`RandomUtilities`**: For generating random letters in the absence of prior data.

---

## **Example Prompt and Output**

### **Input:**

- `wordLength = 5`
- `lines = {}`

### **Generated Prompt:**

`Random an English word that has 5 letters and contain "Y" (answer by syntax {"word":<result>})`

### **Output:**

A random 5-letter word satisfying the condition.

---

### **With Data Example:**

#### **Input:**

```json
lines = {
  1: [
    { "guess": "n", "result": "correct" },
    { "guess": "i", "result": "present" },
    { "guess": "a", "result": "absent" },
  ]
}
```

#### **Generated Prompt:**

```plaintext
Give an English word that must have 5 letters by following the rules:
The word must contain letters: "n", "i"
The word not contains letters: "a"
Letter at index 0 must be "n"
Letter at index 1 cannot be: "i"
```

---

## **Conclusion**

This method demonstrates the use of logical constraints and AI-driven prompts to solve word puzzles efficiently. It highlights effective use of data structures and APIs for dynamic word generation.
