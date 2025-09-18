using Btrak.Models.GenericForm;
using System;

namespace Btrak.Models
{
    public class ActivityModel
    {
        public Guid? Id { get; set; }
        public String ActivityName { get; set; }
        public String Description { get; set; }
        public String Inputs { get; set; }
        public bool? IsArchive { get; set; }
    }

    public class ActivityOutputModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public Guid? DataSourceId { get; set; }
        public bool? IsArchived { get; set; }
        public string ActivityName { get; set; }
        public string Description { get; set; }
        public string Inputs { get; set; }
        public WorkflowModel DataJson { get; set; }

    }

    public class ActivityJsonModel
    {
        public String ActivityName { get; set; }
        public String Description { get; set; }
        public String Inputs { get; set; }
    }
}
