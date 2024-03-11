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

Concept of _load parameters_: metrics by which to define load. Which is relevant depends on the software architecture.

- Concurrent users
- Requests per second
- Ratio of reads to writes to a database
- ...

### Describing Performance

- How is performance affected by increasing load and keeping system resources the same?
- How much do you need to increase system resources to maintain the same performance under increased load?

Some examples of performance metrics:

- **Throughput**: number of records processed per second
- **Response time**: time between client sending a request and receiving a response

There is always a lot of variance that affects performance. Factors like temperature, airflow, mechanical vibrations, can be considered "random" to some degree. Therefore, it is more useful to think of performance as a _distribution of values_. We express this distribution in the form of _percentiles_, for example, _p99_ or _p90_ response time, meaning 99% or 90% of response times, respectively, are faster than that threshold.

### Aproaches for Coping with Load

There is a limit to how much with can cope with increased load without having to rethink our architecture. Within each magnitude of expected load, however, there are ways mitigate loss of performance:

- **Vertical Scaling**: increasing the system resources of the machines running the application
  - Simpler approach, but prohibitively expensive and very prone to diminishing returns
- **Horizontal Scaling**: increasing the number of machines sharing the load
  - Often more adabtible to changes in load, but introduces more complexity

Solutions are highly individual and depend on the nature of the problem at hand, but are made up of a combination of familiar building blocks arranged in common patterns.

### Maintainability

The majority of the cost of software is not in its initial creation, but in its maintenance after the fact: fixing bugs, adapting to new platforms, adding new features etc. It is important that our applications be _maintainable_, that is, easy to be worked on even after the initial implementation is "finished". There are 3 design principles that contribute to software maintainability:

- **Operability**: make it easy for operations to keep the system running smoothly
- **Simplicity**: remove as much complexity from the system as possible and make it easy for new engineers to understand it
- **Evolvability**: make it easy for engineers to make changes to the system in the future

### Operability

Good operability makes routine tasks easier for the operations team:

- Good monitoring providing visibility into runtime behaviour of the system
- Support for automation and integration with standard tools
- Avoiding dependence on individual machines
- Good documentation and easy to understand operational model
- Sane default behaviours with the option to override them
- Self-healing where possible/appropriate, with the possibility of manual control when needed
- Predictable behaviour

### Simplicity: Managing Complexity

Symptoms of complexity include:

- Tight coupling of modules
- Tangled dependencies
- Inconsistencies in naming and terminology
- Special cases to work around issues

Complex software is harder and more expensive to maintain, and makes bugs much more frequent.

A tool to mitigate complexity (when used properly) is _abstraction_, allowing us to hide implementation details where appropriate.

### Evolvability

Requirements change, dependencies change, business priorities change etc. Our software must be able to be adapted when needed. Evolvability is tightly linked to the software's simplicity and the quality of its abstractions.
