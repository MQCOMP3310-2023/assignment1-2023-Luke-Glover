/**
 * @name Combined query
 * @kind problem
 * @problem.severity warning
 * @id java/example/print-stack-trace
 */

 import java

 from 
    RefType throwable,
    MethodAccess methodCall, Method method, 
    MethodAccess parameterMethodCall, Method parameterMethod
 where
    methodCall.getMethod() = method and
    throwable.hasQualifiedName("java.lang", "Throwable") and
    ((
        // Check if printMethod is printStackTrace
        method.hasName("printStackTrace") and
        method.getNumberOfParameters() = 0 and

        // Check if the printStackTrace method belongs to a throwable
        method.getDeclaringType() = throwable
    ) or (
        // Check if printMethod is System.out.println
        method.hasName("println") and
        method.getNumberOfParameters() = 1 and
        method.getDeclaringType().hasQualifiedName("java.io", "PrintStream") and

        // Check if parameter is getMessage or getStackTrace
        parameterMethodCall.getMethod() = parameterMethod and
        parameterMethod.getDeclaringType() = throwable and
        methodCall.getArgument(0) = parameterMethodCall
    ))
     
 select methodCall, "Prints a stacktrace to the console"
 