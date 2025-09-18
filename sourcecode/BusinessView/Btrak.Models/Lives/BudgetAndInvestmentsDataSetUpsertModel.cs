using System;

namespace Btrak.Models.Lives
{
    public class BudgetAndInvestmentsDataSetUpsertModel
    {
        public string Template { get; set; }
        public Object FormData { get; set; }
        public Guid? ProgramId { get; set; }
        public bool? IsArchived { get; set; }
    }

    public class ProgramProgressDataSetUpsertModel
    {
        public string Template { get; set; }
        public string KPIType { get; set; }
        public Object FormData { get; set; }
        public Guid? ProgramId { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsVerified { get; set; }
        
    }
}
