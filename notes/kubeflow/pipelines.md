https://www.kubeflow.org/docs/components/pipelines/v1/sdk/component-development/

# Important: use v1

# Designing a pipeline

- KF Pipeline executes component => container started in k8s pod
- inputs passed as command line arguments
- can pass small inputs (bool/string/ints etc)
- otherwise pass path to file (CSV etc)
- outputs returned as file
- components must be able to read input from stdin
- components are made of 2 files:
  - python file: for component logic
  <!-- - yaml file: defines how the component fits into the pipeline -->
