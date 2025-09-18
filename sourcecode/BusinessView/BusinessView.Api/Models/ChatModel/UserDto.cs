namespace BusinessView.Api.Models.ChatModel
{
    public class UserDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string UserName { get; set; }
        public int RoleId { get; set; }
        public bool IsActive { get; set; }
        public string SurName { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
    }
}