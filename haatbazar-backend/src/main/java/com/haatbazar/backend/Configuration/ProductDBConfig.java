package com.haatbazar.backend.Configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(
        entityManagerFactoryRef = "productEntityFactoryManagerBean",
        basePackages = {"com.haatbazar.backend.Product.repository"},
        transactionManagerRef = "productTransactionManager"
)
public class ProductDBConfig {
    private Environment environment;

    @Autowired
    public ProductDBConfig(Environment environment) {
        this.environment = environment;
    }

    // dataSource
    @Bean(name = "productDBDataSource")
    @Primary
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setUrl(environment.getProperty("spring.product.datasource.url"));
        dataSource.setDriverClassName(environment.getProperty("spring.product.datasource.driver-class-name"));
        dataSource.setUsername(environment.getProperty("spring.product.datasource.username"));
        dataSource.setPassword(environment.getProperty("spring.product.datasource.password"));
        return dataSource;
    }

    // entityManagerFactory
    @Bean(name = "productEntityFactoryManagerBean")
    @Primary
    public LocalContainerEntityManagerFactoryBean entityManagerFactoryBean() {
        LocalContainerEntityManagerFactoryBean bean = new LocalContainerEntityManagerFactoryBean();
        bean.setDataSource(dataSource());
        JpaVendorAdapter adapter = new HibernateJpaVendorAdapter();
        bean.setJpaVendorAdapter(adapter);
        Map<String, String> props = new HashMap<>();
        props.put("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
        props.put("hibernate.show_sql", "true");
        props.put("hibernate.hbm2ddl.auto", "none");
        bean.setJpaPropertyMap(props);
        bean.setPackagesToScan("com.haatbazar.backend.Product.model");
        return bean;
    }

    // platformTransactionManager
    @Bean(name = "productTransactionManager")
    @Primary
    public PlatformTransactionManager transactionManager() {
        JpaTransactionManager manager = new JpaTransactionManager();
        manager.setEntityManagerFactory(entityManagerFactoryBean().getObject());
        return manager;
    }
}
