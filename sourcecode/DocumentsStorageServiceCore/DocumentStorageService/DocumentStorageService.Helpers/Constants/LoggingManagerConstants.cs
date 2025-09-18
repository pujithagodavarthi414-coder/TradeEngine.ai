using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Helpers.Constants
{
    public class LoggingManagerAppConstants
    {
        public static string LoggingManagerInfoValue = "Entering into {0} function in - {1} ";

        public static string LoggingManagerInfoExitingValue = "Exiting from {0} function from - {1} ";

        public static string LoggingManagerDebugValue = "Entering into {0} function with {1} of {2} in - {3} controller ";

        public static string LoggingManagerErrorValue = "Exception occurred in {0} function in - {1} as : {2} ";
    }
}
