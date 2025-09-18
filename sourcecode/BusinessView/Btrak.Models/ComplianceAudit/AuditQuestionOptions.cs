using System;

public class AuditQuestionOptions
{
    public Guid? QuestionOptionId { get; set; }
    public string QuestionOptionName { get; set; }
    public Guid? QuestionTypeOptionId { get; set; }
    public bool QuestionOptionBoolean { get; set; }
    public bool QuestionOptionResult { get; set; }
    public float QuestionOptionScore { get; set; }
    public DateTime? QuestionOptionDate { get; set; }
    public float? QuestionOptionNumeric { get;set; }
    public DateTime? QuestionOptionTime { get; set; }
    public string QuestionOptionTimeResult { get; set; }
    public string QuestionOptionText { get; set; }
    public int? QuestionOptionOrder { get; set; }
}

