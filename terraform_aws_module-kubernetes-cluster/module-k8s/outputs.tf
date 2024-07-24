output "master_public_dns" {
  value = aws_instance.master.public_dns
}

output "master_public_ip" {
    value = aws_instance.master.public_ip
}

output "master_private_dns" {
  value = aws_instance.master.private_dns
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "worker_public_dns" {
  value = aws_instance.worker.public_dns
}

output "worker_public_ip" {
  value = aws_instance.worker.public_ip
}

output "worker_private_dns" {
  value = aws_instance.worker.private_dns
}

output "worker_private_ip" {
  value = aws_instance.worker.private_ip
}
