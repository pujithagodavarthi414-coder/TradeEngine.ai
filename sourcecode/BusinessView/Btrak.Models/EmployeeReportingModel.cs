using System;

namespace Btrak.Models
{
   public  class EmployeeReportingModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        public Guid ReportingMethodId
        {
            get;
            set;
        }
        public Guid ReportToEmployeeId
        {
            get;
            set;
        }
        
        public string ReportingMethod
        {
            get;
            set;
        }
        public string Comments
        {
            get;
            set;
        }
        public string ReportTo
        {
            get;
            set;
        }

        public string loggedusername
        {
            get;
            set;
        }
    }
}
