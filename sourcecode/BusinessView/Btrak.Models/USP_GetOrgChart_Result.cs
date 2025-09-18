namespace Btrak.Models
{
    public class USP_GetOrgChart_Result
    {
        public string Employee_Id { get; set; }
        public string Employee_Name { get; set; }
        public string RoleId { get; set; }
        public string ReportTo { get; set; }
        public string Designation { get; set; }
        public string JoiningDate { get; set; }
        public string ProfileImage { get; set; }
    }
}