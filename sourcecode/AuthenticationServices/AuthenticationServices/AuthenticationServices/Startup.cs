using Hangfire;
using Hangfire.SqlServer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using AuthenticationServices.Common;
using AuthenticationServices.Repositories.Repositories.CompanyManagement;
using AuthenticationServices.Repositories.Repositories.UserAuthTokenRepository;
using AuthenticationServices.Repositories.Repositories.UserManagement;
using AuthenticationServices.Services.Account;
using AuthenticationServices.Services.Email;
using AuthenticationServices.Services.CompanyManagement;
using AuthenticationServices.Services.UserManagement;
using Microsoft.AspNetCore.Authentication;
using AuthenticationServices.Api.Helpers;
using Microsoft.AspNetCore.Http;
using AuthenticationServices.Services.Role;
using AuthenticationServices.Repositories.Repositories.RoleManagement;
using AuthenticationServices.Services.TimeZone;
using AuthenticationServices.Repositories.Repositories.TimeZone;
using AuthenticationServices.Services.MasterData;
using AuthenticationServices.Repositories.Repositories.MasterDataManagement;

namespace AuthenticationServices.Api
{
    public class Startup
    {
        readonly string MyAllowSpecificOrigins = "_myAllowSpecificOrigins";
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        [System.Obsolete]
        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //services.AddControllersWithViews();

            //services.AddAuthorization();

            //services.AddAuthentication("Bearer")
            //    .AddIdentityServerAuthentication(options =>
            //    {
            //        options.Authority = "http://localhost:5000";
            //        options.RequireHttpsMetadata = false;
            //    });
            //services.AddAuthentication("PortalAuthorizeAttribute");
            //.AddScheme<AuthorizeAttribute , PortalAuthorizeAttribute>("BasicAuthentication", null);

            services.AddAuthentication("BasicAuthentication")
                .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

            services.AddControllers();
            services.Configure<AppSettings>(settings =>
            {
                settings.BTrakConnectionString = Configuration["ConnectionStrings:BTrakConnectionString"];
                settings.HangfirePersistence = Configuration["ConnectionStrings:HangfirePersistence"];
                settings.IdentityServerUrl = Configuration["IdentityServerUrl"];
                settings.TimeZoneApi = Configuration["TimeZoneApi"];
                settings.TimeZoneApiFree = Configuration["TimeZoneApiFree"];
            });

            services.AddTransient<IEmailService, EmailService>();
            services.AddTransient<ICompanyManagementService, CompanyManagementService>();
            services.AddTransient<IUserManagementService, UserManagementService>();
            services.AddTransient<ICompanyManagementRepository, CompanyManagementRepository>();
            services.AddTransient<IUserManagementRepository, UserManagementRepository>();
            services.AddTransient<UserAuthTokenRepository, UserAuthTokenRepository>();
            services.AddTransient<BackOfficeService, BackOfficeService>();
            services.AddTransient<IRoleService, RoleService>();
            services.AddTransient<IRoleRepository, RoleRepository>();
            services.AddTransient<ITimeZoneService, TimeZoneService>();
            services.AddTransient<ITimeZoneRepository, TimeZoneRepository>();
            services.AddTransient<IMasterDataManagementService, MasterDataManagementService>();
            services.AddTransient<IMasterDataManagementRepository, MasterDataManagementRepository>();
            services.AddTransient<UserAuthTokenDbHelper, UserAuthTokenDbHelper>();

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();

            services.AddHangfire(configuration => configuration
                .SetDataCompatibilityLevel(CompatibilityLevel.Version_170)
                .UseSimpleAssemblyNameTypeSerializer()
                .UseRecommendedSerializerSettings()
                .UseSqlServerStorage(Configuration.GetConnectionString("HangfirePersistence"), new SqlServerStorageOptions
                {
                    CommandBatchMaxTimeout = TimeSpan.FromMinutes(5),
                    SlidingInvisibilityTimeout = TimeSpan.FromMinutes(5),
                    QueuePollInterval = TimeSpan.Zero,
                    UseRecommendedIsolationLevel = true,
                    DisableGlobalLocks = true,
                    PrepareSchemaIfNecessary = false
                }));

            services.AddCors(options =>
            {
                options.AddPolicy(name: MyAllowSpecificOrigins,
                    builder =>
                    {
                        builder.WithOrigins("https://localhost:4200", "http://localhost:4200");
                        builder.WithHeaders("*");
                        builder.WithMethods("*");
                    });
            });

            services.AddHangfireServer(); 
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseCors(MyAllowSpecificOrigins);

            app.UseHttpsRedirection();
            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
