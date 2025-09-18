using System;

namespace Btrak.Models.Lives
{
    public class ValidatorInputModel
    {
        public Guid? DataSetId { get; set; }
        public bool IsArchived { get; set; }
        public Guid? ProgramId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? ValidatorId { get; set; }
        public Guid? ProgramOwnerId { get; set; }
        public Guid? DownStreamPlayerId { get; set; }
        public Guid? ClientId { get; set; }
        public string Template { get; set; }
        public object FormData { get; set; }
        public bool PerformAuditValidationAccepted { get; set; }
        public bool PerformAuditValidationRejected { get; set; }
        public string PerformAuditAcceptComments { get; set; }
        public string PerformAuditRejectComments { get; set; }
    }
}
