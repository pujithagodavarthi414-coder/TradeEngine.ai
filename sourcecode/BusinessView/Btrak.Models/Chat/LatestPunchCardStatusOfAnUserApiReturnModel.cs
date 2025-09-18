using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Chat
{
    public class LatestPunchCardStatusOfAnUserApiReturnModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public string UserStatus { get; set; }
        public Guid StatusId { get; set; }
        public DateTime StatusTime { get; set; }
    }
}
