# Part 1: Foundations of Data Systems

## Reliable, Scalable and Maintanable Applications

What is a _data-intensive_ application? It means that, unlike with _compute-intensive_ system, the computing power is not the bottleneck. The biggest challenge is the amount and complexity of data being exchanged.

These systems are usually built from standard parts that solve common necessities:

- **Databases** store data and allow it to be queried later on
- A **cache** "saves" the results of an expensive operation, speeding up reads
- **Search indexes** allow searching and filtering of data in various ways
- **Batch processing** crunches big quantities of data in chunks

These are all abstractions that most people take for granted. They are, however, incredibly complex. In this book, we will aim to understand them in more detail and thus be able to make more intelligent choices when it comes to software architecture.

### Thinking About Data Systems

A lot of caches, databases, message queues etc have similar function and the lines between them can get blurry. Furthermore, modern software usually stitches many of them together so they each can do their single, limited function optimally. We refer to a collection of these building blocks as a _data system_.

This way of combining solutions into a big, complex system has its advantages, but it brings forth some challenges:

- How to ensure data remains consistent?
- How to deal with failures along the chain?
- How do we scale the system to handle an increase in load?

These are the topics of the next few sections.

### Reliability

This usually means:

- The application behaves as expected
- It tolerates user error
- It maintains acceptable performance for the given use case under expected load
- It prevents unauthorized access

Essentially, we want things to be _fault-tolerant_ or _resilient_, meaning anticipating and coping with faults in the system. 100% resiliency is impossible, but it is something to strive for. There are different types of faults to consider:

### Hardware Faults

For example, a power grid blackout or a mechanical hard disk failing. These happen all the time, as things naturally degrade with use.

Can be mitigated/dealt with in many ways such as a backup electricity generator and hard drives in a RAID configuration to replicate data. We cannot completely mitigate all faults, but redundancy goes a long way towards reducing their impact.

### Software Errors

- Software bugs can lay dormant for a long time and be triggered by unusual circumstances
- No quick solution to systematic faults, but some things help:
  - Thorough testing
  - Process isolation
  - Measuring/monitoring in production
  - Allowing processes to crash and restart

### Human Error

People inevitably make mistakes, so we must design systems that can deal with that fact. Some approaches:

- Minimize opportunity for error with well designed interfaces and abstractions
  - Make it "easy to do the right thing" and discourage the "wrong thing"
  - Balance between making it restrictive _enough_, but not too much (or people will work around them)
- Decouple common sources of mistakes from where it could lead to system failure
  - Non-production sandbox environments for people to experiment safely
- Thorough tests, from unit testing to end-to-end system integration tests, also covering edge cases
- Allow quick an easy recovery from errors
  - Easy roll back of configuration changes
  - Gradual rollout of new features/changes
  - Allow recomputing data
- Comprehensive monitoring (telemetry) to gather early warning signs and better diagnose issues

### How Important Is Reliability?

Failures can lead to losses in revenue, productivity and consumer trust. They can even lead to legal issues, not to mention the obvious consequences in some specific scenarios (think nuclear power plants, air traffic control systems).

Regardless of the severity of the consequences, we have a responsibility to the users to make our systems reliable.

In some situations we might have to cut corners and balance reliability with development/operational cost, but we should do this consciously.

### Scalability

A system being reliable is not enough. It should to be able to _scale_, that is, deal with increase in load.

### Describing Load
