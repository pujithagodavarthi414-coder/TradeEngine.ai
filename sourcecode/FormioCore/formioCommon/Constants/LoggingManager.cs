using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace formioCommon.Constants
{
    public static class LoggingManager
    {
        //public static ILog Logger = LogManager.GetLogger("LoggingManager");

        //static LoggingManager()
        //{
        //    log4net.Config.XmlConfigurator.Configure();
        //}
        public static ILog Logger = LogManager.GetLogger(typeof(LoggingManager));

        static LoggingManager()
        {
            XmlDocument log4netConfig = new XmlDocument();

            using (var fs = File.OpenRead("log4net.config"))
            {
                log4netConfig.Load(fs);

                var repo = LogManager.CreateRepository(
                        Assembly.GetEntryAssembly(),
                        typeof(log4net.Repository.Hierarchy.Hierarchy));

                log4net.Config.XmlConfigurator.Configure(repo, log4netConfig["log4net"]);
            }
            //log4net.Config.XmlConfigurator.Configure(); // Existing
        }

        public static void Debug(string message)
        {
            Logger.Debug(message);
        }

        public static void Warn(string message)
        {
            Logger.Warn(message);
        }

        public static void Error(string message, Exception exception)
        {
            Logger.Error(message, exception);
        }

        public static void Error(Exception exception)
        {
            Logger.Error(exception);
        }

        public static void Error(string message)
        {
            Logger.Error(message);
        }

        public static void Info(string message)
        {
            Logger.Info(message);
        }

        public static void Info(Func<string> message)
        {
            if (Logger.IsInfoEnabled)
            {
                Logger.Info(message());
            }
        }

        public static void PrintListObject<T>(IEnumerable<T> obj)
        {
#if DEBUG
            foreach (T innerObj in obj)
            {
                PrintObject(innerObj);
            }
#endif
        }

        private static void PrintObject<T>(T obj)
        {
#if DEBUG
            if (obj == null)
            {
                Logger.Info("Null value printed.");
                return;
            }
            string printOutput = obj.GetType().GetProperties().Aggregate(
                                     string.Empty,
                                     (current,
                                      property) =>
                                     {
                                         try
                                         {
                                             return current + (property.Name + "=" + property.GetValue(obj, null)) + ",";
                                         }
                                         catch (Exception)
                                         {
                                             return null;
                                         }
                                     });
            //TraceIntoSystem(printOutput);
            Logger.Info(printOutput);
#endif
        }

        private static string TraceEnterMessage(int param)
        {
            string strMessage = null;
#if DEBUG
            var contextInfo = new ContextInformation(true, param);
            strMessage = "Enter " + contextInfo.Namespace + "." + contextInfo.ClassName + "." + contextInfo.MethodName + "(" + contextInfo.MethodArguments + ")";
#endif
            return strMessage;
        }

        private static string TraceExitMessage(int param = 0)
        {
            string strMessage = null;
#if DEBUG
            var contextInfo = new ContextInformation(true, param);
            strMessage = "Exit " + contextInfo.Namespace + "." + contextInfo.ClassName + "." + contextInfo.MethodName + "(" + contextInfo.MethodArguments + ")";
#endif
            return strMessage;
        }

        private struct ContextInformation
        {
            private const bool CaptureFileInfo = true;
            private const string DefaultText = "<unknown>";
            private const int TargetStackFrame = 2;

            public ContextInformation(bool dummyParam, int param)
            {
                Namespace = DefaultText;
                ClassName = DefaultText;
                MethodName = DefaultText;
                MethodArguments = DefaultText;
                try
                {
                    int targetStackParam = TargetStackFrame + param;
                    var stack = new StackTrace(CaptureFileInfo);
                    if (stack.FrameCount >= targetStackParam + 1)
                    {
                        StackFrame targetStackFrame = stack.GetFrame(targetStackParam + 1);
                        MethodBase callingMethod = targetStackFrame.GetMethod();
                        Namespace = callingMethod.ReflectedType?.Namespace;
                        ClassName = callingMethod.ReflectedType?.Name;
                        MethodName = callingMethod.Name;
                        var methodArguments = new StringBuilder();
                        ParameterInfo[] methodParameters = callingMethod.GetParameters();
                        for (int parameterIndex = 0; parameterIndex < methodParameters.Length; parameterIndex++)
                        {
                            methodArguments.Append(methodParameters[parameterIndex].ParameterType.Name);
                            methodArguments.Append(" ");
                            methodArguments.Append(methodParameters[parameterIndex].Name);
                            if (parameterIndex < (methodParameters.Length - 1))
                            {
                                methodArguments.Append(", ");
                            }
                        }
                        MethodArguments = methodArguments.ToString();
                    }
                }
                catch (Exception exception)
                {
                    Trace.WriteLine(exception);
                }
            }

            public string ClassName
            {
                get;
            }

            public string MethodArguments
            {
                get;
            }

            public string MethodName
            {
                get;
            }

            public string Namespace
            {
                get;
            }
        }
    }
}
