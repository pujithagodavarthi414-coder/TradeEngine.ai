using Btrak.Models;
using BTrak.Common;
using System;


    public class SubmitAuditConductApiInputModel : InputModelBase
    {
        public SubmitAuditConductApiInputModel() : base(InputTypeGuidConstants.SubmitAuditConductQuestionApiInputModelCommandTypeGuid)
        {
        }

        public Guid? ConductAnswerSubmittedId { get; set; }
        public Guid? AuditConductAnswerId { get; set; }
        public string AnswerComment { get; set; }
        public Guid? IsArchived { get; set; }
        public DateTime? QuestionOptionDate{ get; set; }
        public float? QuestionOptionNumeric{ get; set; }
        public DateTime? QuestionOptionTime{ get; set; }
        public string QuestionOptionText{ get; set; }
        public Guid? QuestionId { get; set; }
        public Guid? ConductId { get; set; }    
        public Guid? AuditConductQuestionId { get; set; }
        public bool? EnableQuestionLevelWorkFlow { get; set; }
        public Guid? QuestionWorkflowId { get; set; }
}
