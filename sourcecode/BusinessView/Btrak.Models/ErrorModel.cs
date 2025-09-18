using Btrak.Models.GenericForm;
using System;

namespace Btrak.Models
{
    public class ErrorModel
    {
        public Guid? Id { get; set; }
        public String ErrorCode { get; set; }
        public String Description { get; set; }
        public String ErrorMessage { get; set; }
        public bool? IsArchive { get; set; }
    }

    public class ErrorOutputModel
    {
        public Guid? Id { get; set; }
        public string Description { get; set; }
        public string ErrorCode { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? DataSourceId { get; set; }
        public WorkflowModel DataJson { get; set; }
        public string Name { get; set; }
        public string ErrorMessage { get; set; }

    }
}
