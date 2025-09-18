using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class TimesheetAuditModel
    {
        public Guid UserId
        {
            get;
            set;
        }
        public Guid? FeatureId
        {
            get;
            set;
        }
        public Guid? UserStoryId
        {
            get;
            set;
        }
        public DateTime ViewedDate
        {
            get;
            set;
        }
        public string AuditDescription
        {
            get;
            set;
        }
        public string UserName
        {
            get;
            set;
        }

        public string FeatureName
        {
            get;
            set;
        }

        public DateTime CreatedDateTime
        {
            get;
            set;
        }
    }
}
