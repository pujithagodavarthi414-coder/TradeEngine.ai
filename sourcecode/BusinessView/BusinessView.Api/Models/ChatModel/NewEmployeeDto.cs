namespace BusinessView.Api.Models.ChatModel
{
    public class NewEmployeeDto
    {
        public string Name { get; set; }
        public string SurName { get; set; }
        public string EmailId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeRole { get; set; }
        public string EmployeeJobLocation { get; set; }
        public string EmployeeTimeZone { get; set; }
        public string MobileNumber { get; set; }
        public bool IsAdmin { get; set; }
    }
}