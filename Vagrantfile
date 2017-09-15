Vagrant.configure("2") do |config|
  #config.vm.box = "hashicorp/precise32"
  config.vm.box = "ubuntu_aws"
  
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = "minha key id"
    aws.secret_access_key = "minha access key"

    aws.region = "us-west-2"
    aws.instance_type = "t2.micro"
    aws.keypair_name = "devops"
    #aws.ami = "ami-6e1a0117" #16.04
    aws.ami = "ami-718c6909" #14.04
    aws.security_groups = ['devops']
    
    
    #Só funcionou pós inserir o id da subnet e associar a um ip público
    #aws.subnet_id = "id da subnet"
    #aws.associate_public_ip = true
    
    
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "devops.pem"
  end
  
  config.vm.define :web do |web_config|
  
    web_config.vm.network "private_network", ip: "192.168.50.10"
    web_config.vm.provision "shell", path: "manifests/bootstrap.sh"
    web_config.vm.provision "puppet" do |puppet|
      puppet.manifest_file = "web.pp"
    end
    
    web_config.vm.provider :aws do |aws|
      aws.tags = { 'Name' => 'MusicJungle (vagrant)'}
    end
    
  end
  #config.vm.define :secundaria do |web_config|
  #end
  
end
