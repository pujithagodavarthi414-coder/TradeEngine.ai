using DocumentStorageService.Helpers.Constants;
using System;
using System.Threading.Tasks;

namespace DocumentStorageService.Services.Helpers
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
    }
}
