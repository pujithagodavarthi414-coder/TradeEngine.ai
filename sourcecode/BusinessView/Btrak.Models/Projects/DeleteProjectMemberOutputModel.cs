using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Projects
{
    public class DeleteProjectMemberOutputModel
    {
        public Guid Id { get; set; }
        public string TextMessage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" Id = " + Id);
            stringBuilder.Append(" TextMessage = " + TextMessage);
            return stringBuilder.ToString();
        }
    }
}
