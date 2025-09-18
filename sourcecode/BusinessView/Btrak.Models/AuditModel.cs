
using System;
using System.ComponentModel.DataAnnotations.Schema;
using Newtonsoft.Json;

namespace Btrak.Models
{
    public class AuditModel
    {
        public Object AuditObject
        {
            get;
            set;
        }

        public string AuditJson => JsonConvert.SerializeObject(AuditObject);

        public bool? IsOldAudit { get; set; }

        public DateTime CreatedDateTime
        {
            get;
            set;
        }

        public Guid CreatedByUserId
        {
            get;
            set;
        }

        [DatabaseGeneratedAttribute(DatabaseGeneratedOption.Computed)]
        public Guid GuidId
        {
            get;
            set;
        }

        public Guid FeatureId { get; set; }
        public Guid CompanyGuid { get; set; }
    }

    public class AuditJsonModel
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
        public DateTime Date
        {
            get;
            set;
        }
        public string Description
        {
            get;
            set;
        }
        public string FieldName
        {
            get;
            set;
        }
        public string UserName
        {
            get;
            set;
        }
        public DateTime CreatedDate
        {
            get;
            set;
        }
        public string CreatedDateTime
        {
            get;
            set;
        }
    }

    public class AuditHistoryModel
    {
        public Guid UserId { get; set; }
        public Guid? FeatureId { get; set; }
        public Guid? UserStoryId { get; set; }
        public string AuditJson { get; set; }
        public DateTime? ViewedDate { get; set; }
        public string UserName { get; set; }
        public string FeatureName { get; set; }
        public string Description { get; set; }
        public string FieldName { get; set; }
        public string ProfileImage { get; set; }
    }
}
