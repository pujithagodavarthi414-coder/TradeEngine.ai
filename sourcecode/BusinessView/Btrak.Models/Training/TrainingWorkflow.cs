using System;

namespace Btrak.Models.Training
{
    public class TrainingWorkflow
    {
        public Guid Id { get; set; }
        public Guid AssignmentId { get; set; }
        public Guid StatusId { get; set; }
        public DateTime? StatusGivenDate { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public bool IsExpiryStatus { get; set; }
    }
}
