import re
from collections import Counter

def clean_text(text):
    """Removes special characters and converts text to lowercase."""
    text = re.sub(r'[^\w\s]', '', text)  # remove punctuation
    text = text.lower()  # convert to lowercase
    return text

def extract_keywords(job_description):
    """Extracts keywords from the job description."""
    job_description = clean_text(job_description)
    words = job_description.split()
    return Counter(words)

def match_keywords(resume, job_description_keywords):
    """Matches resume keywords with job description keywords."""
    resume = clean_text(resume)
    resume_words = resume.split()

    matched = {word: job_description_keywords[word] for word in resume_words if word in job_description_keywords}
    missing = {word: job_description_keywords[word] for word in job_description_keywords if word not in resume_words}

    return matched, missing

def suggest_improvements(missing_keywords):
    """Suggests improvements by including missing keywords."""
    suggestions = f"\nConsider including the following keywords to better align with the job description:\n"
    for keyword, freq in missing_keywords.items():
        suggestions += f"- {keyword} (mentioned {freq} times in the job description)\n"
    return suggestions

# Sample inputs
job_description = """We are looking for a Principal DevSecOps Engineer with expertise in automation, CI/CD pipelines, cloud infrastructure, and security best practices. Proficiency in Python, AWS, and Docker is a must. The ideal candidate should also have experience with Kubernetes and Terraform."""
resume = """Principal DevOps Engineer with extensive experience in automation, cloud platforms, and security. Skilled in Python and Docker."""

# Extract keywords from job description
job_keywords = extract_keywords(job_description)

# Match keywords with resume
matched_keywords, missing_keywords = match_keywords(resume, job_keywords)

# Output the results
print(f"Matched Keywords: {matched_keywords}")
print(f"Missing Keywords: {missing_keywords}")

# Suggest improvements
print(suggest_improvements(missing_keywords))
