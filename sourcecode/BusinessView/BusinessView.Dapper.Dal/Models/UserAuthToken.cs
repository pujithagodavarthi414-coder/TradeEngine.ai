using System;

namespace Btrak.Dapper.Dal.Models
{
	public class UserAuthTokenDbEntity
	{
		/// <summary>
		/// Gets or sets the Id value.
		/// </summary>
		public Guid Id
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserId value.
		/// </summary>
		public Guid? UserId
		{ get; set; }

		/// <summary>
		/// Gets or sets the UserName value.
		/// </summary>
		public string UserName
		{ get; set; }

		/// <summary>
		/// Gets or sets the DateCreated value.
		/// </summary>
		public DateTime? DateCreated
		{ get; set; }

		/// <summary>
		/// Gets or sets the AuthToken value.
		/// </summary>
		public string AuthToken
		{ get; set; }

		/// <summary>
		/// Gets or sets the CompanyId value.
		/// </summary>
		public Guid? CompanyId
		{ get; set; }

	}
}
