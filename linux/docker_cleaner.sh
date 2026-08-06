#!/bin/bash
# Docker Cleaner Script - Cleanup containers, images, volumes, networks
# Author: System Admin
# Usage: ./docker_cleaner.sh [-a all] [-i images] [-v volumes] [-o orphan]

VERSION="1.0"
LOG_FILE="/var/log/docker_cleaner.log"
DRY_RUN=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TOTAL_CLEANED=0

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_docker_running() {
    if ! docker info >/dev/null 2>&1; then
        log "[ERROR] Docker is not running or not accessible"
        return 1
    fi
    return 0
}

get_size() {
    local size="$1"
    if [ -z "$size" ] || [ "$size" = "0B" ]; then
        echo "0B"
    else
        echo "$size"
    fi
}

clean_stopped_containers() {
    log "Cleaning stopped containers..."
    local stopped=$(docker ps -q -f status=exited 2>/dev/null | wc -l)
    
    if [ "$stopped" -gt 0 ]; then
        log "Found $stopped stopped containers"
        if [ "$DRY_RUN" = false ]; then
            local cleaned=$(docker rm $(docker ps -q -f status=exited) 2>/dev/null | wc -l)
            log "Removed $cleaned stopped containers"
            ((TOTAL_CLEANED += cleaned))
        else
            log "[DRY RUN] Would remove $stopped containers"
        fi
    else
        log "No stopped containers to remove"
    fi
}

clean_dangling_images() {
    log "Cleaning dangling images..."
    local dangling=$(docker images -q -f dangling=true 2>/dev/null | wc -l)
    
    if [ "$dangling" -gt 0 ]; then
        log "Found $dangling dangling images"
        if [ "$DRY_RUN" = false ]; then
            local space_saved=$(docker rmi $(docker images -q -f dangling=true) 2>&1 | tail -1)
            log "Removed dangling images: $(get_size "$space_saved")"
            ((TOTAL_CLEANED += dangling))
        else
            log "[DRY RUN] Would remove $dangling images"
        fi
    else
        log "No dangling images to remove"
    fi
}

clean_unused_images() {
    log "Cleaning unused images (older than 7 days)..."
    local images=$(docker images --format "{{.ID}} {{.CreatedAt}}" | awk -v cutoff=$(date -d "7 days ago" +%s) '{
        cmd = "date -d \"" $2 " " $3 "\" +%s"
        cmd | getline created
        close(cmd)
        if (created < cutoff) print $1
    }' 2>/dev/null | wc -l)
    
    if [ "$images" -gt 0 ]; then
        log "Found $images images older than 7 days"
        if [ "$DRY_RUN" = false ]; then
            docker images --format "{{.ID}} {{.CreatedAt}}" | while read id date time rest; do
                created=$(date -d "$date $time" +%s 2>/dev/null)
                cutoff=$(date -d "7 days ago" +%s)
                if [ "$created" -lt "$cutoff" ]; then
                    docker rmi "$id" 2>/dev/null
                fi
            done
            log "Removed unused images"
        else
            log "[DRY RUN] Would remove $images images"
        fi
    else
        log "No unused images older than 7 days"
    fi
}

clean_dangling_volumes() {
    log "Cleaning dangling volumes..."
    local dangling=$(docker volume ls -q -f dangling=true 2>/dev/null | wc -l)
    
    if [ "$dangling" -gt 0 ]; then
        log "Found $dangling dangling volumes"
        if [ "$DRY_RUN" = false ]; then
            docker volume rm $(docker volume ls -q -f dangling=true) 2>/dev/null
            log "Removed $dangling dangling volumes"
            ((TOTAL_CLEANED += dangling))
        else
            log "[DRY RUN] Would remove $dangling volumes"
        fi
    else
        log "No dangling volumes to remove"
    fi
}

clean_unused_networks() {
    log "Cleaning unused networks..."
    local networks=$(docker network ls -q 2>/dev/null | wc -l)
    local used=0
    
    for net in $(docker network ls -q); do
        if [ -n "$(docker network inspect -f '{{.Containers}}' "$net" | grep -v "{}")" ]; then
            ((used++))
        fi
    done
    
    local unused=$((networks - used))
    if [ "$unused" -gt 0 ]; then
        log "Found $unused unused networks"
        if [ "$DRY_RUN" = false ]; then
            for net in $(docker network ls -q); do
                if [ -z "$(docker network inspect -f '{{.Containers}}' "$net" | grep -v "{}")" ]; then
                    docker network rm "$net" 2>/dev/null
                fi
            done
            log "Removed $unused unused networks"
            ((TOTAL_CLEANED += unused))
        else
            log "[DRY RUN] Would remove $unused networks"
        fi
    else
        log "No unused networks to remove"
    fi
}

clean_build_cache() {
    log "Cleaning build cache..."
    if [ "$DRY_RUN" = false ]; then
        docker builder prune -f 2>/dev/null
        log "Build cache cleaned"
    else
        log "[DRY RUN] Would clean build cache"
    fi
}

clean_all() {
    log "=========================================="
    log "Running FULL Docker cleanup"
    log "=========================================="
    
    clean_stopped_containers
    clean_dangling_images
    clean_dangling_volumes
    clean_unused_networks
    clean_build_cache
    
    log "=========================================="
    log "Full cleanup completed. Total items cleaned: $TOTAL_CLEANED"
    log "=========================================="
}

show_disk_usage() {
    echo "=========================================="
    echo "Docker Disk Usage"
    echo "=========================================="
    
    if command -v df >/dev/null 2>&1; then
        local docker_root=$(docker info -f '{{.DockerRootDir}}' 2>/dev/null)
        if [ -n "$docker_root" ]; then
            echo "Docker directory: $docker_root"
            du -sh "$docker_root" 2>/dev/null
        fi
    fi
    
    echo ""
    echo "Images:"
    docker images --format "{{.Size}} {{.Repository}}:{{.Tag}}" | sort -hr | head -10
    
    echo ""
    echo "Volumes:"
    docker system df -v 2>/dev/null | head -20
}

show_summary() {
    echo ""
    echo "=========================================="
    echo "Docker Cleaner Summary"
    echo "=========================================="
    echo "Total items cleaned: $TOTAL_CLEANED"
    echo "Log file: $LOG_FILE"
    echo "=========================================="
}

while getopts "aicvonbdsh" opt; do
    case $opt in
        a) clean_all; show_summary; exit 0 ;;
        i) clean_dangling_images; show_summary; exit 0 ;;
        v) clean_dangling_volumes; show_summary; exit 0 ;;
        o) clean_unused_networks; show_summary; exit 0 ;;
        n) clean_unused_images; show_summary; exit 0 ;;
        b) clean_build_cache; show_summary; exit 0 ;;
        c) clean_stopped_containers; show_summary; exit 0 ;;
        d) DRY_RUN=true ;;
        s) show_disk_usage; exit 0 ;;
        h) echo "Usage: $0 [-a all] [-i images] [-v volumes] [-o networks] [-c containers] [-n unused_images] [-b build_cache] [-d dry_run] [-s status]"; exit 0 ;;
    esac
done

if ! check_docker_running; then
    exit 1
fi

echo "Docker Cleaner Script v$VERSION"
echo "Use -h for help"
echo "Use -a for full cleanup"