using formioServices.Audits;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using MongoDB.Bson;
using MongoDB.Bson.Serialization;
using MongoDB.Bson.Serialization.Serializers;
using formioRepo.DataSource;
using formioServices.Data;
using formioRepo.DataSet;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Formio.Helpers;
using formioServices.data;
using formioRepo.DataSourceKeys;
using formioRepo.DataSourceKeysConfiguration;
using formioRepo.DataSetHistory;
using formioRepo.DataSourceHistory;
using System.Threading.Tasks;
using formioRepo.Dashboard;
using Formio.Hubs;
using formioCommon.Hubs;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using formioRepo.DataLevelKeyConfiguration;
using formioRepo.PdfDesigner;

namespace Formio
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            BsonSerializer.RegisterSerializer(new GuidSerializer(BsonType.String));
            services.AddCors(o => o.AddPolicy("CorsPloicy", builder =>
            {
                builder
                    .AllowAnyMethod()
                    .AllowAnyHeader()
                    .AllowAnyOrigin();
                //.AllowCredentials();
            }));
            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = "Formio",
                    Version = "v1"
                });

                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    In = ParameterLocation.Header,
                    Description = "Please insert JWT with Bearer into field",
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey
                });

                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                          Reference = new OpenApiReference
                          {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                          }
                        },
                        new string[] { }
                    }
                });
            });
            services.AddSingleton<IUserIdProvider, NameUserIdProvider>();
            services.AddSignalR();
            services.AddTransient<IDataSourceRepository, DataSourceRepository>();
            services.AddTransient<IDataSetRepository, DataSetRepository>();
            services.AddTransient<IDataSourceKeysRepository, DataSourceKeysRepository>();
            services.AddTransient<IDataSourceKeysConfigurationRepository, DataSourceKeysConfigurationRepository>();
            services.AddTransient<IDataSetHistoryRepository, DataSetHistoryRepository>(); 
            services.AddTransient<IDataSourceHistoryRepository, DataSourceHistoryRepository>();
            services.AddTransient<IPdfDesignerRepository, PdfDesignerRepository>();
            services.AddTransient<IDataSetService, DataSetService>();
            services.AddTransient<IDataSourceService, DataSourceService>();
            services.AddTransient<IDataSourceKeysService, DataSourceKeysService>();
            services.AddTransient<IDataSourceKeysConfigurationService, DataSourceKeysConfigurationService>();
            services.AddTransient<IDataSetHistoryService, DataSetHistoryService>();
            services.AddTransient<IDataSourceHistoryService, DataSourceHistoryService>();
            services.AddTransient<IDataLevelKeyConfigurationService,DataLevelKeyConfigurationService>();
            services.AddTransient<IDataLevelKeyConfigurationRepository, DataLevelKeyConfigurationRepository>();
            services.AddTransient<IPdfDesignerService, PdfDesignerService>();
            services.AddTransient<IAuditService, AuditService>();
            services.AddTransient<DashboardRepository, DashboardRepository>();
            services.AddTransient<DashboardRepositoryNew, DashboardRepositoryNew>();
            services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null).AddCookie();
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddTransient<DashboardRepository, DashboardRepository>();
            services.AddTransient<DashboardRepositoryNew, DashboardRepositoryNew>();
            services.AddTransient<INotificationService, NotificationService>();
            //services.AddAuthentication(options =>
            //{
            //    // Identity made Cookie authentication the default.
            //    // However, we want JWT Bearer Auth to be the default.
            //    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
            //    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            //}).AddJwtBearer(options =>
            //{
            //    // Configure the Authority to the expected value for
            //    // the authentication provider. This ensures the token
            //    // is appropriately validated.
            //    options.Authority = "https://localhost:54580/"; // TODO: Update URL

            //    // We have to hook the OnMessageReceived event in order to
            //    // allow the JWT authentication handler to read the access
            //    // token from the query string when a WebSocket or 
            //    // Server-Sent Events request comes in.

            //    // Sending the access token in the query string is required due to
            //    // a limitation in Browser APIs. We restrict it to only calls to the
            //    // SignalR hub in this code.
            //    // See https://docs.microsoft.com/aspnet/core/signalr/security#access-token-logging
            //    // for more information about security considerations when using
            //    // the query string to transmit the access token.
            //    options.Events = new JwtBearerEvents
            //    {
            //        OnMessageReceived = context =>
            //        {
            //            var accessToken = context.Request.Query["access_token"];

            //            // If the request is for our hub...
            //            var path = context.HttpContext.Request.Path;
            //            if (!string.IsNullOrEmpty(accessToken) &&
            //                (path.StartsWithSegments("/lookupsync")))
            //            {
            //                // Read the token out of the query string
            //                context.Token = accessToken;
            //            }
            //            return Task.CompletedTask;
            //        }
            //    };
            //});
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Formio v1"));
            }
            app.Use(async (context, next) =>
            {
                var accessToken = context.Request.Query["access_token"];
                if (!string.IsNullOrEmpty(accessToken))
                {
                    context.Request.Headers.Add("Authorization", accessToken);
                }
                await next();
            });
            app.UseAuthentication();
            app.UseHttpsRedirection();
            app.UseCors("CorsPloicy");
            app.UseRouting();

            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapHub<LookupSyncNotification>("/lookupsync");
            });
            app.Run(context =>
            {
                context.Response.Redirect("/swagger");
                return Task.CompletedTask;
            });

        }
    }
}
