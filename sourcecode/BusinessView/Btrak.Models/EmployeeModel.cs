using System;

namespace Btrak.Models
{
    public class EmployeeTerminationModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid TerminationReasonId
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        public bool IsTerminated
        {
            get;
            set;
        }
        public DateTime TerminatedDate
        {
            get;
            set;
        }
        public DateTime CreatedDateTime
        {
            get;
            set;
        }
        public Guid CreatedByUserId
        { get; set; }
    }
}


