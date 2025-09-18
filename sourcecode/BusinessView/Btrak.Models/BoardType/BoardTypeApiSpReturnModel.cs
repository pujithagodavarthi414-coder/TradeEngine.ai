using System;

namespace Btrak.Models.BoardType
{
    public class BoardTypeApiSpReturnModel
    {
        public Guid? BoardTypeApiId { get; set; }
        public string ApiName { get; set; }
        public string ApiUrl { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
