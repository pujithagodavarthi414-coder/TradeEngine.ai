using Btrak.Models.User;
using System;
using System.Collections.Generic;

namespace Btrak.Models.Lives
{
    public class UserLevelAccessModel
    {
        public Guid? Id { get; set; }
        public List<Guid?> UserIds { get; set; }
        public Guid? UserId { get; set; }
        public Guid? UserAutheticationId { get; set; }
        public Guid? ProgramId { get; set; }
        public List<Guid?> LevelIds { get; set; }
        public string LevelXml { get; set; }
        public Guid? ClientId { get; set; }
        public List<Guid?> RoleIds { get; set; }
        public string RoleXml { get; set; }
        public string ReferenceText { get; set; }
        public string LevelName { get; set; }
        public bool IsLevelRemovel { get; set; }
    }
    public class UserLevelAccessOutputModel
    {
        public Guid? UserId { get; set; }
        public Guid? ProgramId { get; set; }
        public string FullName { get; set; }
        public Guid? LevelId { get; set; }
    }
}
