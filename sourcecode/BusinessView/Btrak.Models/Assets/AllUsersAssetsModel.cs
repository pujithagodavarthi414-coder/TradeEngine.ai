using System;
using System.Text;

namespace Btrak.Models.Assets
{
    public class AllUsersAssetsModel
    {
        public string Assets { get; set; }

        public string UserName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Assets" + Assets);
            stringBuilder.Append(", UserName" + UserName);
            return stringBuilder.ToString();
        }
    }
}
