using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class DropdownModel
    {
        public Guid? Id { get; set; }
        public string Value { get; set; }
        public string TestCaseType { get; set; }
        public byte[] TimeStamp { get; set; }
        public string StatusHexValue { get; set; }
        public Guid? ParentSectionId { get; set; }
        public Guid? ParentCategoryId { get; set; }
        public string OriginalName { get; set; }
        public string Description { get; set; }
        public Guid? TestSuiteId { get; set; }
        public bool? IsArchive { get; set; }
        public string TestCaseStatus { get; set; }
        public string StatusShortName { get; set; }
        public string ProfileImage { get; set; }
        public bool? IsDefault { get; set; }
        public Guid? AuditVersionId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", Value = " + Value);
            stringBuilder.Append(", TestCaseType = " + TestCaseType);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", ParentSectionId = " + ParentSectionId);
            stringBuilder.Append(", ParentCategoryId = " + ParentCategoryId);
            stringBuilder.Append(", OriginalName = " + OriginalName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", IsArchive = " + IsArchive);
            stringBuilder.Append(", StatusHexValue = " + StatusHexValue);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            return stringBuilder.ToString();
        }
    }
}