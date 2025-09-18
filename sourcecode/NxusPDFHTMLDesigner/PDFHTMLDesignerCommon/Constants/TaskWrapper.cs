using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerCommon.Constants
{
    public class TaskWrapper
    {
        public static void ExecuteFunctionInNewThread(Action action)
        {
            try
            {
                Task.Factory.StartNew(() =>
                {
                    try
                    {
                        action();
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExecuteFunctionInNewThread", "TaskWrapperClass", exception.Message), exception);
                    }
                });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExecuteFunctionInNewThread", "TaskWrapperClass", exception.Message), exception);

            }
        }

        public static async Task<T> ExecuteFunctionOnBackgroundThread<T>(Func<T> action)
        {
            try
            {
                return await Task.Factory.StartNew(function: () =>
                {
                    try
                    {
                        T result = action();

                        return result;
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExecuteFunctionOnBackgroundThread", "TaskWrapperClass", exception.Message), exception);

                        return default(T);
                    }
                });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExecuteFunctionOnBackgroundThread", "TaskWrapperClass", exception.Message), exception);

            }

            return default(T);
        }
    }
}
