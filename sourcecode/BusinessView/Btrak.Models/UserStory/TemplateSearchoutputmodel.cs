using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class TemplateSearchoutputmodel
    {
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? TemplateId { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? WorkFlowId { get; set; }
        public string Workflow { get; set; }
        public string OwnerName { get; set; }
        public string TemplateName { get; set; }
        public string OwnerProfileImage { get; set; }
        public string DependencyProfileImage { get; set; }
        public string DependencyName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTime? DeadLineDate { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public string UserStoryName { get; set; }
        public int Order { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Description { get; set; }
        public string UserStoryTypeName { get; set; }
        public string UserStoryTypeColor { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TemplateId = " + TemplateId);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", Workflow = " + Workflow);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", TemplateName = " + TemplateName);
            stringBuilder.Append(", OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(", DependencyProfileImage = " + DependencyProfileImage);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", Order = " + Order);
            return stringBuilder.ToString();
        }
    }
}
