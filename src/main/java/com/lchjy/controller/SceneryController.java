package com.lchjy.controller;

import com.lchjy.entity.NingboScenery;
import com.lchjy.service.SceneryService;
import com.lchjy.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/scenery")
@Slf4j
public class SceneryController {

    @Autowired
    private SceneryService sceneryService;

    @GetMapping("/list")
    public Result list(@RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        log.info("查询景点列表: keyword={}, page={}, limit={}", keyword, page, limit);
        return Result.success(sceneryService.list(keyword, page, limit));
    }

    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        log.info("查询景点详情: id={}", id);
        return Result.success(sceneryService.getById(id));
    }

    @PostMapping("/add")
    public Result add(@RequestBody NingboScenery scenery) {
        log.info("新增景点: {}", scenery);
        sceneryService.add(scenery);
        return Result.success();
    }

    @PostMapping("/update")
    public Result update(@RequestBody NingboScenery scenery) {
        log.info("修改景点: {}", scenery);
        sceneryService.update(scenery);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        log.info("删除景点: id={}", id);
        sceneryService.delete(id);
        return Result.success();
    }
}
