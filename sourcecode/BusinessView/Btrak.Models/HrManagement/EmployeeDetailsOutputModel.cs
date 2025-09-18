using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeDetailsOutputModel
    {
        public Guid? UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
        public string ProfileImage { get; set; }
        public string CompanyName { get; set; }
        public string CompanyWebsite { get; set; }
        public string Note { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zipcode { get; set; }
        public string CountryName { get; set; }
        public string BranchName { get; set; }
        public string DesignationName { get; set; }
        public string RoleIds { get; set; }
        public string RoleName { get; set; }
        public string Education { get; set; }
        public string Experience { get; set; }
        public string Skill { get; set; }
        public string Language { get; set; }
        public string ReportTo { get; set; }
        public string ApprovedLeaves { get; set; }
        public string RemainingLeaves { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", MobileNumber = " + MobileNo);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", CompanyName = " + CompanyName);
            stringBuilder.Append(", CompanyWebsite = " + CompanyWebsite);
            stringBuilder.Append(", Note = " + Note);
            stringBuilder.Append(", Street = " + Street);
            stringBuilder.Append(", City = " + City);
            stringBuilder.Append(", State = " + State);
            stringBuilder.Append(", Zipcode = " + Zipcode);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", ApprovedLeaves = " + ApprovedLeaves);
            stringBuilder.Append(", RemainingLeaves = " + RemainingLeaves);
            stringBuilder.Append(", Education = " + Education);
            stringBuilder.Append(", Experience = " + Experience);
            stringBuilder.Append(", Skill = " + Skill);
            stringBuilder.Append(", Language = " + Language);
            stringBuilder.Append(", ReportTo = " + ReportTo);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}